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
}

private extension Array where Element == String {
    func optionalAll() -> [String] {
        return self.map { $0.last != "?" ? "\($0)?" : $0 }
    }
}

extension Array where Element == [String] {
    func mergeWithOptional() -> [String] {
        guard !self.isEmpty else { return [] }
        guard self.count != 1 else { return self[0] }
        var array = self.map { NSOrderedSet(array: $0).array as? [String] ?? [] }

        // Could not allow empty
        guard array.filter({ $0.isEmpty }).isEmpty else {
            return array.filter({ !$0.isEmpty }).mergeWithOptional().optionalAll()
        }

        var result: [String] = []
        var base: [String] = array[0]
        array = Array(array[1..<array.count])

        for (i, e) in base.enumerated() {
        }

        return result
    }
}
