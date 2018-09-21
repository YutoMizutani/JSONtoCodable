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

    enum TranslateState {
        case prepareKey, inKey, prepareValue, inValue, inArray(Any)
    }

    public var config: Config = Config()

    // MARK: - Initializers

    public init() {}
}

// MARK: - public methods

public extension JSONtoCodable {
    func translate(_ text: String) throws -> String {
        var isStartCurlyBracket: Bool?

        var properties: [Property] = []
        var state: TranslateState = .prepareKey
        var json: RawJSON = (key: "", value: "", type: nil)

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

        func startValue(isString: Bool) {
            json.type = isString ? .string : nil
            state = .inValue
        }
        func addValue(_ c: Character) {
            json.value.append(c)
        }
        func endValue() throws {
            guard !properties.isEmpty else { throw JSONError.wrongFormat }

            if json.type == nil {
                json.type = self.decisionType(json.value, isString: json.type == .string)
            }
            guard let immutable = createImmutable(json) else { throw JSONError.wrongFormat }
            properties[properties.count - 1].immutables.append(immutable)
            properties[properties.count - 1].codingKeys.append(createCodingKey(json.key))

            state = .prepareKey
        }

        func startStruct() throws {
            // end value
            json.type = .struct
            try endValue()

            // add property
            let caseType = config.caseType.struct
            let property = Property(json.key.updateCased(with: caseType), accessModifer: config.accessModifer)
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
                if isStartCurlyBracket == nil {
                    isStartCurlyBracket = character == "{"
                }

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
                default:
                    let isString = character == "\""
                    startValue(isString: isString)
                    if !isString {
                        json.value.append(character)
                    }
                }
            case .inValue:
                switch character {
                case "\"":
                    try endValue()
                case " ", "\r", "\n":
                    if json.type == .string {
                        addValue(character)
                    } else {
                        try endValue()
                    }
                default:
                    addValue(character)
                }
            case .inArray:
                switch character {
                default:
                    break
                }
            }
        }

        if let isStartCurlyBracket = isStartCurlyBracket, !isStartCurlyBracket {
            endStruct()
        }

        return self.createStructScope(properties.first!)
    }
}

// MARK: - internal methods

extension JSONtoCodable {
    func decisionType(_ value: String, isString: Bool) -> Type {
        guard !isString else { return Type.string }

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

    func createImmutable(_ json: RawJSON) -> String? {
        guard let seedType = json.type else { return nil }
        let accessModifer: AccessModifer = config.accessModifer
        let caseTypes = config.caseType

        let prefix: String = accessModifer == .default ? "" : "\(accessModifer.rawValue) "
        let key: String = json.key.updateCased(with: caseTypes.variable)
        let type: String = json.type != .struct ? seedType.rawValue : json.key.updateCased(with: caseTypes.struct)
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
