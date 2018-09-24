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
        return self.separated.joined(with: caseType)
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
        let replaceWords: [Character] = ["-", "_"]
        let last: Character = replaceWords.last!
        var text = self != self.uppercased() ? self.changeCased() : self
        Array(replaceWords.dropLast()).forEach { key in
            text = text.replacingOccurrences(of: String(key), with: String(last))
        }
        return text.split(separator: last).map { String($0) }
    }

    fileprivate func optional() -> String {
        return self.last != "?" ? "\(self)?" : self
    }
}

private extension Array where Element == String {
    func optionalAll() -> [String] {
        return self.map { $0.optional() }
    }
}

extension Array where Element == [String] {
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
