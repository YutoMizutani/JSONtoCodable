//
//  String+.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

extension String {
    var separated: [String] {
        let replaceWords: [Character] = ["-", "_"]
        let last: Character = replaceWords.last!
        var text = self
        Array(replaceWords.dropLast()).forEach { key in
            text = text.replacingOccurrences(of: String(key), with: String(last))
        }
        return text.split(separator: last).map { String($0) }
    }
}
