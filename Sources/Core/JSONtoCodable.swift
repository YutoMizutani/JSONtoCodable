//
//  JSONtoCodable.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

public class JSONtoCodable {
    typealias RawJSON = (key: String, value: String, type: Type?)
    typealias ImmutableSeed = (key: String, type: Type)

    enum GenerateState {
        case prepareKey, inKey, prepareValue, inValue, inArray
    }

    public var config: Config = Config()

    // MARK: - Initializers

    public init() {}
}

// MARK: - public methods

public extension JSONtoCodable {
    func generate(_ text: String) throws -> String {
        var properties: [Property] = []
        var state: GenerateState = .prepareKey
        var json: RawJSON = (key: "", value: "", type: nil)

        /// Array values
        var values: [String] = []

        func ignore() {}
        func startKey() {
            state = .inKey
            json = ("", "", nil)
        }
        func addKey(_ c: Character) {
            json.key.append(c)
        }
        func endKey() {
            state = .prepareValue
        }

        func startValue() {
            state = .inValue
        }
        func addValue(_ c: Character) throws {
            if case GenerateState.inArray = state {
                guard !values.isEmpty else { throw JSONError.wrongFormat }
                values[values.count - 1].append(c)
            } else {
                json.value.append(c)
            }
        }
        func endValue() throws {
            guard !properties.isEmpty else { throw JSONError.wrongFormat }

            if json.type == nil {
                json.type = self.decisionType(json.value)
            }
            guard let immutable = createImmutable(json) else { throw JSONError.wrongFormat }
            properties[properties.count - 1].immutables.append(immutable)
            properties[properties.count - 1].codingKeys.append(createCodingKey(json.key))

            state = .prepareKey
        }

        func startArray() {
            state = .inArray
            values = [""]
        }
        func addArrayValue(_ c: Character) throws {
            guard !values.isEmpty else { throw JSONError.wrongFormat }
            values[values.count - 1].append(c)
        }
        func nextArray() {
            values.append("")
        }
        func endArray() throws {
            json.type = decisionType(values)
            try endValue()
            state = .prepareKey
        }

        func startStruct() throws {
            let caseType: CaseType = config.caseType.struct
            let type: String = json.key.updateCased(with: caseType)

            // end value
            json.type = .struct(type)
            try endValue()

            // add property
            let property = Property(type, accessModifer: config.accessModifer)
            properties.append(property)
            state = .prepareKey
        }
        func endStruct() {
            guard properties.count >= 2 else { return }
            let structString: String = self.createStructScope(properties.last!)
            properties.remove(at: properties.count - 1)
            properties[properties.count - 1].structs.append(structString)
        }

        properties.append(Property(config.name, accessModifer: config.accessModifer))
        for character in text {
            switch state {
            case .prepareKey:
                switch character {
                case "\"":
                    startKey()
                case " ":
                    ignore()
                case "}":
                    endStruct()
                default:
                    ignore()
                }
            case .inKey:
                switch character {
                case "\"":
                    endKey()
                default:
                    addKey(character)
                }
            case .prepareValue:
                switch character {
                case ":", " ":
                    ignore()
                case "{":
                    try startStruct()
                case "[":
                    startArray()
                default:
                    startValue()
                    try addValue(character)
                }
            case .inValue:
                switch character {
                case "\"":
                    try addValue(character)
                    try endValue()
                case " ", "\r", "\n":
                    if decisionType(json.value) == .string {
                        try addValue(character)
                    } else {
                        try endValue()
                    }
                default:
                    try addValue(character)
                }
            case .inArray:
                switch character {
                case "]":
                    try endArray()
                case ",":
                    nextArray()
                case " ", "\r", "\n":
                    guard !values.isEmpty else { throw JSONError.wrongFormat }
                    if decisionType(values[values.count - 1]) == .string {
                        try addArrayValue(character)
                    }
                default:
                    try addArrayValue(character)
                }
            }
        }

        return self.createStructScope(properties.first!)
    }
}

// MARK: - internal methods

extension JSONtoCodable {
    func decisionType(_ value: String) -> Type {
        if String(value.prefix(1)) == "\"" {
            return .string
        }

        switch value.lowercased() {
        case "true", "false":
            return .bool
        case "nil", "null":
            return.optionalAny
        case let value where value == Int(value)?.description:
            return .int
        case let value where value == Double(value)?.description:
            return .double
        default:
            return .any
        }
    }

    func decisionType(_ values: [String]) -> Type {
        return values.map { decisionType($0) }.sumType()
    }

    func createImmutable(_ json: RawJSON) -> String? {
        guard let type = json.type?.rawValue else { return nil }
        let accessModifer: AccessModifer = config.accessModifer
        let caseTypes = config.caseType

        let prefix: String = accessModifer == .default ? "" : "\(accessModifer.rawValue) "
        let key: String = json.key.updateCased(with: caseTypes.variable)
        return "\(prefix)let \(key): \(type)"
    }

    func createCodingKey(_ jsonKey: String) -> String {
        let caseType = config.caseType.variable

        let key: String = jsonKey.updateCased(with: caseType)
        return "case \(key == jsonKey ? key : "\(key) = \"\(jsonKey)\"")"
    }

    func createCodingKeyScope(_ keys: [String]) -> String? {
        guard !keys.filter({ $0.contains("=") }).isEmpty else { return nil }

        let indent: String = config.indentType.rawValue
        let line: String = config.lineType.rawValue
        let prefix: String = "private enum CodingKeys: String, CodingKey {"
        let suffix: String = "}"

        let contents: String = keys.map { indent + $0 }.joined(separator: line)

        return [prefix, contents, suffix].joined(separator: line)
    }

    func createStructScope(_ property: Property) -> String {
        let line: String = config.lineType.rawValue
        let indent: String = config.indentType.rawValue

        let prefix: String = property.prefix
        let suffix: String = property.suffix ?? ""

        let immutableString: String = property.immutables.joined(separator: line)
        let internalStructString: String? = !property.structs.isEmpty ? property.structs.joined(separator: "\(line)\(line)") : nil
        let codingKeyString: String? = self.createCodingKeyScope(property.codingKeys)

        var contents: String = [immutableString, internalStructString, codingKeyString]
            .filter { $0 != nil }.map { $0! }
            .joined(separator: "\(line)\(line)")
            .replacingOccurrences(of: line, with: "\(line)\(indent)")
            .replacingOccurrences(of: "\(line)\(indent)\(line)", with: "\(line)\(line)")
        contents = indent + contents
        return [prefix, contents, suffix].joined(separator: line)
    }
}
