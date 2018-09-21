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

    func changeCased() -> String {
        return (self as NSString).replacingOccurrences(of: "([A-Z])",
                                                       with: "-$1",
                                                       options: .regularExpression,
                                                       range: NSRange(location: 0, length: count)
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    var separated: [String] {
        let replaceWords: [Character] = ["-", "_"]
        let last: Character = replaceWords.last!
        var text = self != self.uppercased() ? self.changeCased() : self
        Array(replaceWords.dropLast()).forEach { key in
            text = text.replacingOccurrences(of: String(key), with: String(last))
        }
        return text.split(separator: last).map { String($0) }
    }
}
