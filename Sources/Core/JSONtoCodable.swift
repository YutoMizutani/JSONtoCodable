//
//  JSONtoCodable.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

public class JSONtoCodable {
    private typealias Property = ([String], [String])
    private typealias Register = (isString: Bool, value: String)
    private typealias ImmutableSeed = (key: String, type: Type)

    public var config: Config = Config()
}

// MARK: - private methods

private extension JSONtoCodable {
    private func createResult(_ properties: [Property]) -> String {
        let line: String = config.lineType.rawValue
        let indent: String = config.indentType.rawValue
        var result: (prefix: String, suffix: String) = ("", "")
        for property in properties.enumerated() {
            // Add line
            if property.offset != 0 {
                result.prefix += line
                result.suffix = !property.element.1.isEmpty ? line + result.suffix : result.suffix
            }

            let indents = String(repeating: indent, count: property.offset)
            result.prefix += property.element.0.map { $0 != "" ? indents + $0 : $0 }.joined(separator: line)
            result.suffix = !property.element.1.isEmpty ? property.element.1.joined(separator: line) + result.suffix : result.suffix
        }
        return "\(result.prefix)\(line)\(result.suffix != "}" ? line : "")\(result.suffix)"
    }

    private func createStruct(_ name: String) -> Property {
        let accessModifer: String = config.accessModifer == .default ? "" : "\(config.accessModifer.rawValue) "
        return (["\(accessModifer)struct \(name): Codable {"], ["}"])
    }

    private func createImmutable(_ seed: ImmutableSeed) -> (translatedKey: String, value: String) {
        let accessModifer: AccessModifer = config.accessModifer
        let caseType: CaseType = config.caseType.variable
        let prefix: String = accessModifer == .default ? "" : "\(accessModifer.rawValue) "
        let key: String = seed.key.separated.joined(with: caseType)
        return (key, "\(prefix)let \(key): \(seed.type.rawValue)")
    }

    private func createSeed(_ key: String, register: Register) -> ImmutableSeed {
        guard !register.isString else {
            return (key: key, type: .string)
        }

        var seed: ImmutableSeed = (key, .any)
        print("###", #function, "'\(register.value)'")
        switch register.value.lowercased() {
        case "true", "false":
            seed.type = .bool
        case "nil", "null":
            seed.type = .optionalAny
        case let value where value == Int(value)?.description:
            seed.type = .int
        case let value where value == Double(value)?.description:
            seed.type = .double
        default:
            print("default!")
            seed.type = .any
        }

        return seed
    }

    private func createCodingKeysString(_ codingKeys: [(key: String, value: String)]) -> String? {
        guard codingKeys.filter({ $0.key != $0.value }).count > 0 else { return nil }

        let indent: String = config.indentType.rawValue
        let line: String = config.lineType.rawValue
        let prefix: String = "private enum CodingKeys: String, CodingKey {"
        let suffix: String = "}"
        let content = codingKeys
            .map { $0.key == $0.value ? "\($0.key)" : "\($0.key) = \"\($0.value)\"" }
            .map { "\(indent)case \($0)" }
            .joined(separator: line)
        return [prefix, content, suffix].map { "\(indent)\($0)" }.joined(separator: line)
    }
}

// MARK: - public methods

public extension JSONtoCodable {
    func translate(_ json: String) throws -> String {
        var isStartCurlyBracket: Bool? = nil

        var properties: [Property] = [self.createStruct(config.name), ([], [])]
        var codingKeys: [[(key: String, value: String)]] = [[]]
        var state: TranslateState = .prepareKey

        var register: Register? = nil
        var stack: [String] = []

        func ignore() {}
        func startKey() {
            state = .inKey
            register = (true, "")
        }
        func addKey(_ c: Character) {
            register?.value.append(c)
        }
        func endKey() throws {
            guard let key = register?.value else { throw JSONError.wrongFormat }
            stack.append(key)
            register = nil
            state = .prepareValue
        }

        func startValue(isString: Bool) {
            register = (isString, "")
            state = .inValue
        }
        func addValue(_ c: Character) {
            register?.value.append(c)
        }
        func endValue() throws {
            guard
                let key = stack.last, let regist = register,
                !properties.isEmpty, !codingKeys.isEmpty
                else { throw JSONError.wrongFormat }

            let seed: ImmutableSeed = createSeed(key, register: regist)
            let immutable = createImmutable(seed)
            properties[properties.count-1].0.append(immutable.value)
            codingKeys[codingKeys.count-1].append((immutable.translatedKey, seed.key))
            stack.remove(at: stack.count-1)
            register = nil
            state = .prepareKey
        }

        func startStruct() throws {
            guard let name = stack.last else { throw JSONError.wrongFormat }
            stack.remove(at: stack.count-1)
            let property = createStruct(name)
            properties.append(property)
            codingKeys.append([])
            state = .prepareKey
        }
        func endStruct() throws {
            guard !properties.isEmpty, !codingKeys.isEmpty else { throw JSONError.wrongFormat }
            if let codingKeyString: String = createCodingKeysString(codingKeys[codingKeys.count-1]) {
                properties[properties.count-1].1.insert(codingKeyString, at: 0)
            }
            codingKeys.remove(at: codingKeys.count-1)
        }

        for character in json {
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
                    try endStruct()
                default:
                    ignore()
                }
            case .inKey:
                switch character {
                case "\"":
                    try endKey()
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
                        register?.value.append(character)
                    }
                }
            case .inValue:
                switch character {
                case "\"":
                    try endValue()
                case " ", "\r", "\n":
                    guard let regist = register else { throw JSONError.wrongFormat }
                    if regist.isString {
                        addValue(character)
                    } else {
                        try endValue()
                    }
                default:
                    addValue(character)
                }
            case .inArray(let content):
                switch character {
                default:
                    break
                }
            }
        }

        if let isStartCurlyBracket = isStartCurlyBracket, !isStartCurlyBracket {
            try endStruct()
        }

        return self.createResult(properties)
    }
}
