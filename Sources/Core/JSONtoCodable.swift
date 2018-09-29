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
        case prepareKey, inKey, prepareValue, inValue, inArray, inArrayObject(Int)
    }

    public var config: Config = Config()

    // MARK: - Initializers

    public init() {}
}

// MARK: - public methods

public extension JSONtoCodable {
    func generate(_ text: String) throws -> String {
        let indentType = self.config.indentType
        self.config.indentType = .space(4)
        let property = try self.generateProperty(text)
        let duplicatedResult: String = self.createStructScope(property)
        var result = removeDuplicated(duplicatedResult)
        result = result.replacingOccurrences(of: self.config.indentType.rawValue, with: indentType.rawValue)
        return result
    }
}

extension JSONtoCodable {
    func removeDuplicated(_ text: String) -> String {
        let lineType: LineType = config.lineType
        let indentType = config.indentType
        let accessModifer = config.accessModifer

        let replacedLine: Character = "\n"
        let array = text.replacingOccurrences(of: lineType.rawValue, with: "\(replacedLine)").components(separatedBy: .newlines)

        struct Directory {
            var prefix: String
            var immutables: [String]
            var codingKeys: [String]
            var suffix: String
            var contents: [String]
            var directories: [Directory]

            var value: [String] {
                let p = [self.prefix]
                let i = !self.immutables.isEmpty ? self.immutables : []
                let c = !self.codingKeys.isEmpty ? [""] + self.codingKeys : self.codingKeys
                let s = [self.suffix]
                return p + i + self.contents + c + s
            }
        }

        func analyseDirecoty(_ directory: Directory) -> Directory {
            var directory = directory
            let array = directory.contents
            var ignoreLine: Int = 0
            let accessModiferText = accessModifer.rawValue != "" ? "\(accessModifer.rawValue) " : ""
            var hasStruct: Bool = false

            for (i, e) in array.enumerated() {
                guard i >= ignoreLine else { continue }
                if e.hasSuffix(": Codable {") && e.replacingOccurrences(of: indentType.rawValue, with: "").hasPrefix("\(accessModiferText)struct") {
                    hasStruct = true
                    let indents: String = String(e[e.startIndex..<e.replacingOccurrences(of: accessModiferText, with: "").range(of: "struct")!.lowerBound])
                    let bracket: String = "\(indents)}"
                    for (si, se) in array.enumerated() {
                        guard si > i else { continue }
                        if se == bracket {
                            ignoreLine = si
                            var dir = Directory(
                                prefix: e,
                                immutables: [],
                                codingKeys: [],
                                suffix: se,
                                contents: Array(array[i + 1..<si]),
                                directories: []
                            )
                            if i > 0 && array[i - 1] == "" && Array(array[0..<i - 1]).filter({ $0.hasSuffix(": Codable {") }).isEmpty {
                                directory.immutables = Array(array[0..<i - 1])
                            }
                            if array.count > si + 1 && array[si + 1] == "" && array[si + 2].contains("enum CodingKeys: String, CodingKey {") {
                                directory.codingKeys = Array(array[si + 2..<array.count])
                            }

                            dir = analyseDirecoty(dir)
                            directory.directories.append(dir)
                            break
                        }
                    }
                }
            }
            if !hasStruct {
                if let index = array.index(of: "") {
                    directory.immutables = Array(array[0..<index])
                    directory.codingKeys = array.count > index ? Array(array[index + 1..<array.count]) : []
                } else {
                    directory.immutables = array
                }
                directory.contents = []
            }

            return directory
        }
        var directory = Directory(
            prefix: "",
            immutables: [],
            codingKeys: [],
            suffix: "",
            contents: array,
            directories: []
        )
        directory = analyseDirecoty(directory)

        func setDirectories(_ directories: [Directory]) -> [Directory] {
            /// Remove duplicated in imutables
            func mergeImutables(_ rhs: [String], _ lhs: [String]) -> [String] {
                var merged = [rhs, lhs].mergeWithOptional()
                merged = Array(NSOrderedSet(array: merged)) as! [String]
                return merged
            }

            /// Remove duplicated in content
            func mergeContents(_ rhs: [String], _ lhs: [String]) -> [String] {
                var merged = [rhs + lhs].merge()
                merged = Array(NSOrderedSet(array: merged)) as! [String]
                return merged
            }

            /// Remove duplicated in codingkeys
            func mergeCodingKeys(_ rhs: [String], _ lhs: [String]) -> [String] {
                guard !rhs.isEmpty, !lhs.isEmpty else {
                    return rhs + lhs
                }

                var merged = [Array(rhs[1..<rhs.count - 1]) + Array(lhs[1..<lhs.count - 1])].merge()
                merged.insert(rhs[0], at: 0)
                merged.append(rhs[rhs.count - 1])
                merged = NSOrderedSet(array: merged).array as! [String]
                return merged
            }

            func removeDuplicate(_ rhs: Directory, _ lhs: Directory) -> Directory {
                var directory = rhs
                directory.immutables = mergeImutables(rhs.immutables, lhs.immutables)
                directory.codingKeys = mergeCodingKeys(rhs.codingKeys, lhs.codingKeys)
                directory.contents = []
                directory.directories += lhs.directories

                var settedDirectories: [Directory] = []
                for d in directory.directories {
                    let prefix = d.prefix

                    if let resultDir = settedDirectories.first(where: { $0.prefix == prefix }) {

                        for (i, e) in settedDirectories.enumerated() where e.prefix == prefix {
                            settedDirectories[i] = removeDuplicate(resultDir, d)
                            break
                        }
                    } else {
                        settedDirectories.append(d)
                        continue
                    }
                }
                directory.directories = settedDirectories
                return directory
            }

            var settedDirectories: [Directory] = []
            for directory in directories {
                let prefix = directory.prefix

                if let resultDir = settedDirectories.first(where: { $0.prefix == prefix }) {
                    for (i, e) in settedDirectories.enumerated() where e.prefix == prefix {
                        settedDirectories[i] = removeDuplicate(resultDir, directory)
                        break
                    }
                } else {
                    settedDirectories.append(directory)
                    continue
                }
            }

            if !settedDirectories.filter({ !$0.directories.isEmpty }).isEmpty {
                for (i, e) in settedDirectories.enumerated() {
                    settedDirectories[i].directories = setDirectories(e.directories)
                }
            }
            return settedDirectories
        }

        func mergeDirectries(_ directories: [Directory]) -> [String] {
            let directories = directories.map {
                Directory(
                    prefix: $0.prefix,
                    immutables: $0.immutables,
                    codingKeys: $0.codingKeys,
                    suffix: $0.suffix,
                    contents: !$0.directories.isEmpty ? mergeDirectries($0.directories) : $0.contents,
                    directories: []
                )
            }
            return directories.map { $0.value }.reduce([]) { $0 + [""] + $1 }
        }

        let settedDirectories = setDirectories(directory.directories)
        var mergedContents = mergeDirectries(settedDirectories)
        mergedContents = Array(mergedContents[1..<mergedContents.count])
        let result = mergedContents.map { $0.replacingOccurrences(of: "\(replacedLine)", with: lineType.rawValue) }.joined(separator: lineType.rawValue)
        return result
    }
}

// MARK: - internal methods

extension JSONtoCodable {
    func generateProperty(_ text: String) throws -> Property {
        var isStartedArray: Bool?

        var properties: [Property] = []
        var state: GenerateState = .prepareKey
        var json: RawJSON = (key: "", value: "", type: nil)

        var register: String = ""

        /// Array values
        var values: [String] = []
        var arrayProperties: [Property] = []

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
        func addValue(_ c: Character) {
            json.value.append(c)
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
            arrayProperties = []
        }
        func addArrayValue(_ c: Character) throws {
            guard !values.isEmpty else { throw JSONError.wrongFormat }
            values[values.count - 1].append(c)
        }
        func nextArray() {
            values.append("")
        }
        func finishMainArrayObject() throws {
            guard let property = merge(arrayProperties) else { throw JSONError.wrongFormat }
            properties = [property]
        }
        func finishArrayObject() throws {
            let caseType = config.caseType.struct
            let name = config.name
            let structName = json.key.updateCased(with: caseType)

            guard let property = merge(arrayProperties) else { throw JSONError.wrongFormat }
            json.type = Type.structArray(structName)
            guard !properties.isEmpty else { throw JSONError.wrongFormat }
            property.prefix = property.prefix.replacingOccurrences(of: name, with: structName)
            let structString: String = createStructScope(property)
            properties[properties.count - 1].structs.append(structString)
        }
        func endArray() throws {
            if isStartedArray == true {
                try finishMainArrayObject()
            } else {
                if values.filter({ $0 != "" }).isEmpty && !arrayProperties.isEmpty {
                    try finishArrayObject()
                } else {
                    json.type = decisionType(values)
                }

                try endValue()
            }

            state = .prepareKey
        }

        func startArrayObject() {
            state = .inArrayObject(1)
            register = ""
        }
        func addArrayObject(_ n: Int) {
            let n = n + 1
            state = .inArrayObject(n)
        }
        func addArrayObjectValue(_ c: Character) {
            register.append(c)
        }
        func removeArrayObject(_ n: Int) throws {
            let n = n - 1
            state = .inArrayObject(n)
            if n == 0 {
                try endArrayObject()
            }
        }
        func endArrayObject() throws {
            let property = try generateProperty(register)
            arrayProperties.append(property)
            state = .inArray
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
                    if isStartedArray == nil {
                        isStartedArray = false
                    }
                    startKey()
                case " ", ",":
                    ignore()
                case "}":
                    endStruct()
                case "[":
                    if isStartedArray == nil {
                        isStartedArray = true
                    }
                    startArray()
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
                    addValue(character)
                }
            case .inValue:
                switch character {
                case "\"":
                    addValue(character)
                    if String(json.value.suffix(2)) != "\\\"" {
                        try endValue()
                    }
                case " ", "\r", "\n", ",":
                    if decisionType(json.value) == .string {
                        addValue(character)
                    } else {
                        try endValue()
                    }
                default:
                    addValue(character)
                }
            case .inArray:
                switch character {
                case "{":
                    startArrayObject()
                    addArrayObjectValue(character)
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
            case .inArrayObject(let n):
                addArrayObjectValue(character)
                switch character {
                case "{":
                    addArrayObject(n)
                case "}":
                    try removeArrayObject(n)
                default:
                    break
                }
            }
        }

        return properties.first!
    }

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
        return "case \((key == jsonKey || key == jsonKey.escaped()) ? key : "\(key) = \"\(jsonKey)\"")"
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

    func mergeStructs(_ structs: [String]) -> [String] {
        let lineType = config.lineType
        let indentType = config.indentType

        func merge(_ lhs: String, _ rhs: String) -> String? {
            func split(_ text: String) -> [String] {
                let replacedLine: Character = "\n"
                return text.replacingOccurrences(of: lineType.rawValue, with: "\(replacedLine)")
                    .split(separator: replacedLine)
                    .map { $0.replacingOccurrences(of: "\(replacedLine)", with: lineType.rawValue) }
            }
            var lhs: [String] = split(lhs)
            var rhs: [String] = split(rhs)

            guard lhs.count >= 2, lhs.first == rhs.first, lhs.last == rhs.last else { return nil }
            let prefix = [lhs.first!]
            let suffix = [lhs.last!]
            lhs = Array(lhs[1..<lhs.count - 1])
            rhs = Array(rhs[1..<rhs.count - 1])

            var rawContents: [String] = [lhs, rhs].mergeWithOptional()
            FixFormat: for (i, e) in rawContents.enumerated() {
                // Remove optional mark in CodingKeys and Brackets
                if e.last == "?" && !e.contains("let") {
                    rawContents[i] = String(e[e.startIndex..<e.index(before: e.endIndex)])
                }
                // Add lines on CodingKeys
                if rawContents[i].contains("enum CodingKeys: String, CodingKey {") || rawContents[i].contains(": Codable {") {
                    rawContents[i] = lineType.rawValue + rawContents[i]
                }
            }

            return (prefix + rawContents + suffix).joined(separator: lineType.rawValue)
        }

        guard !structs.isEmpty else { return structs }

        var result: [String] = [structs.first!]
        for r in Array(structs[1..<structs.count]) {
            for (ri, re) in result.enumerated() {
                if let mergedStruct = merge(re, r) {
                    result[ri] = mergedStruct
                    break
                }
                if ri == result.count - 1 {
                    result.append(r)
                }
            }
        }

        return result
    }

    func merge(_ properties: [Property]) -> Property? {
        guard !properties.isEmpty else { return nil }

        let property = properties[0]
        property.immutables = properties.map { $0.immutables }.mergeWithOptional()
        guard let structs: [String] = (NSOrderedSet(array: properties.map { $0.structs }.flatMap { $0 }).array as? [String]) else { return nil }
        property.structs = structs
        property.codingKeys = properties.map { $0.codingKeys }.merge()
        return property
    }
}
