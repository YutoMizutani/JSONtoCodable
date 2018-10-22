//
//  Extensions.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import JSONtoCodable

extension AccessModifier {
    init?(_ text: String) {
        switch text {
        case "d", "default":
            self = .default
        case "pr", "private":
            self = .private
        case "f", "fileprivate":
            self = .fileprivate
        case "i", "internal":
            self = .internal
        case "pu", "public":
            self = .public
        case "o", "open":
            self = .open
        default:
            return nil
        }
    }
}

extension CaseType {
    init?(_ text: String) {
        switch text {
        case "p", "pascal":
            self = .pascal
        case "c", "camel":
            self = .camel
        case "sn", "snake":
            self = .snake
        case "ss", "screamingSnake":
            self = .screamingSnake
        default:
            return nil
        }
    }
}

extension LineType {
    init?(_ text: String) {
        switch text {
        case "\n", "n", "lineFeed":
            self = .lineFeed
        case "\r", "r", "carriageReturn":
            self = .carriageReturn
        case "\r\n", "rn", "both":
            self = .both
        default:
            return nil
        }
    }
}

extension IndentType {
    init?(_ text: String) {
        guard let num = Int(String(text[text.index(after: text.startIndex)..<text.endIndex])) else { return nil }

        if text.hasPrefix("s") {
            self = .space(num)
        } else if text.hasPrefix("t") {
            self = .tab(num)
        }

        return nil
    }
}
