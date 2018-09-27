//
//  String+.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

extension String {
    func updateCased(with caseType: CaseType) -> String {
        return self.escapeSymbols().separated.joined(with: caseType).escapedByReservedWords()
    }

    private func changeCased() -> String {
        return (self as NSString).replacingOccurrences(of: "([A-Z])",
                                                       with: "-$1",
                                                       options: .regularExpression,
                                                       range: NSRange(location: 0, length: count)
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    private var separated: [String] {
        let replaceWords: [Character] = ["-", "_", ":"]
        let last: Character = replaceWords.last!
        var text = self != self.uppercased() ? self.changeCased() : self
        Array(replaceWords.dropLast()).forEach { key in
            text = text.replacingOccurrences(of: String(key), with: String(last))
        }
        return text.split(separator: last).map { String($0) }
    }

    func escaped() -> String {
        return "`\(self)`"
    }

    private func escapedByReservedWords() -> String {
        let declarationsAndTypeKeywords: [String] = [
            "class",
            "destructor",
            "extension",
            "import",
            "init",
            "func",
            "enum",
            "protocol",
            "struct",
            "subscript",
            "Type",
            "typealias",
            "var",
            "where"
        ]
        let statements: [String] = [
            "break",
            "case",
            "continue",
            "default",
            "do",
            "else",
            "if",
            "in",
            "for",
            "return",
            "switch",
            "then",
            "while"
        ]
        let expressions: [String] = [
            "as",
            "is",
            "new",
            "super",
            "self",
            "Self",
            "type",
            "__COLUMN__",
            "__FILE__",
            "__LINE__"
        ]

        return (declarationsAndTypeKeywords + statements + expressions).filter({ $0 == self }).isEmpty ? self : self.escaped()
    }

    private func escapeSymbols() -> String {
        let symbols: [String] = ["@"]
        var escaped: String = self
        symbols.forEach { escaped = escaped.replacingOccurrences(of: $0, with: "") }
        return escaped
    }

    fileprivate func optional() -> String {
        return self.last != "?" ? "\(self)?" : self
    }
}

extension Array where Element == String {
    private func optionalAll() -> [String] {
        return self.map { $0.optional() }
    }

    func mergeStructs(with lineType: LineType) -> [String] {
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
            for (i, e) in rawContents.enumerated() {
                if e.last == "?" && !e.contains("let") {
                    rawContents[i] = String(e[e.startIndex..<e.index(before: e.endIndex)])
                }
                if rawContents[i].contains("enum CodingKeys: String, CodingKey {") {
                    rawContents[i] = lineType.rawValue + rawContents[i]
                }
            }

            return (prefix + rawContents + suffix).joined(separator: lineType.rawValue)
        }

        guard !self.isEmpty else { return self }

        var result: [String] = [self.first!]
        for r in Array(self[1..<self.count]) {
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
}

extension Array where Element == [String] {
    func merge() -> [String] {
        guard !self.isEmpty else { return [] }
        guard self.count != 1 else { return self[0] }
        let array = self.map { NSOrderedSet(array: $0).array as? [String] ?? [] }

        // Could not allow empty
        guard array.filter({ $0.isEmpty }).isEmpty else {
            return array.filter({ !$0.isEmpty }).merge()
        }

        var rawResult: [String] = []
        for a in array {
            var stack: [String] = []
            for t in a {
                stack.append(t)
                if let index = rawResult.index(of: t) {
                    rawResult.insert(contentsOf: stack, at: index)
                    stack = []
                }
            }
            rawResult += stack
        }

        return NSOrderedSet(array: rawResult).array as? [String] ?? []
    }

    func mergeWithOptional() -> [String] {
        guard !self.isEmpty else { return [] }
        guard self.count != 1 else { return self[0] }
        let count = self.count
        let array = self.map { NSOrderedSet(array: $0).array as? [String] ?? [] }

        // Could not allow empty
        guard array.filter({ $0.isEmpty }).isEmpty else {
            return array.filter({ !$0.isEmpty }).mergeWithOptional().optionalAll()
        }

        var rawResult: [String] = []
        for a in array {
            var stack: [String] = []
            for t in a {
                stack.append(t)
                if let index = rawResult.index(of: t) {
                    rawResult.insert(contentsOf: stack, at: index)
                    stack = []
                }
            }
            rawResult += stack
        }

        var result: [String] = NSOrderedSet(array: rawResult).array as? [String] ?? []
        result = result.map { r in rawResult.filter({ $0 == r }).count == count ? r : r.optional() }
        return result
    }
}
