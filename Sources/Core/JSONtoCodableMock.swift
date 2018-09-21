//
//  JSONtoCodableMock.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

public class JSONtoCodableMock {
    typealias Property = (prefix: String, structs: String?, suffix: String?)
    typealias Register = (isString: Bool, value: String)
    typealias ImmutableSeed = (key: String, type: Type)

    enum TranslateState {
        case prepareKey, inKey, prepareValue, inValue, inArray(Any)
    }

    public var config: Config = Config()
}

extension JSONtoCodableMock {
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

    func createStructFrame(_ key: String) -> Property {
        let accessModifer: String = config.accessModifer == .default ? "" : "\(config.accessModifer.rawValue) "
        return ("\(accessModifer)struct \(key): Codable {", nil, "}")
    }

    func createImmutable(_ seed: ImmutableSeed) -> String {
        let accessModifer: AccessModifer = config.accessModifer
        let caseTypes = config.caseType

        let prefix: String = accessModifer == .default ? "" : "\(accessModifer.rawValue) "
        let key: String = seed.key.updateCased(with: caseTypes.variable)
        let type: String = seed.type != .struct ? seed.type.rawValue : seed.key.updateCased(with: caseTypes.struct)
        return "\(prefix)let \(key): \(type)"
    }

    func createCodingKey(_ jsonKey: String) -> String {
        let caseType = config.caseType.variable

        let key: String = jsonKey.updateCased(with: caseType)
        return "case \(key == jsonKey ? key : "\(key) = \"\(jsonKey)\"")"
    }

    func createCodingKeyScope(_ keys: [String]) -> String? {
        guard !keys.isEmpty else { return nil }

        let indent: String = config.indentType.rawValue
        let line: String = config.lineType.rawValue
        let prefix: String = "private enum CodingKeys: String, CodingKey {"
        let suffix: String = "}"

        let contents: String = keys.map { indent + $0 }.joined(separator: line)

        return [prefix, contents, suffix].joined(separator: line)
    }

    func createStructScope(_ frame: Property, immutables: [String], codingKeys: [String]) -> String {
        let line: String = config.lineType.rawValue
        let indent: String = config.indentType.rawValue

        let prefix: String = frame.prefix
        let suffix: String = frame.suffix ?? ""

        let immutableString: String = immutables.joined(separator: line)
        let internalStructString: String? = frame.structs
        let codingKeyString: String? = self.createCodingKeyScope(codingKeys)

        var contents: String = [immutableString, internalStructString, codingKeyString]
            .filter { $0 != nil }.map { $0! }
            .joined(separator: "\(line)\(line)")
            .replacingOccurrences(of: line, with: "\(line)\(indent)")
            .replacingOccurrences(of: "\(line)\(indent)\(line)", with: "\(line)\(line)")
        contents = indent + contents
        return [prefix, contents, suffix].joined(separator: line)
    }
}
