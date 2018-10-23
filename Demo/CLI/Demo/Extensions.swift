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

    var parameterString: String {
        switch self {
        case .default:
            return "default"
        case .private:
            return "private"
        case .fileprivate:
            return "fileprivate"
        case .internal:
            return "internal"
        case .public:
            return "public"
        case .open:
            return "open"
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
        case "ss", "screaming-snake":
            self = .screamingSnake
        default:
            return nil
        }
    }

    var parameterString: String {
        switch self {
        case .pascal:
            return "PascalCase"
        case .camel:
            return "camelCase"
        case .snake:
            return "snake_case"
        case .screamingSnake:
            return "SCREAMING_SNAKE_CASE"
        }
    }
}

extension LineType {
    init?(_ text: String) {
        switch text {
        case "\n", "\\n", "n", "line-feed":
            self = .lineFeed
        case "\r", "\\r", "r", "carriage-return":
            self = .carriageReturn
        case "\r\n", "\\r\\n", "rn", "both":
            self = .both
        default:
            return nil
        }
    }

    var parameterString: String {
        switch self {
        case .lineFeed:
            return "Line Feed (LF)"
        case .carriageReturn:
            return "Carriage Return (CR)"
        case .both:
            return "Both (CRLF)"
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

    var parameterString: String {
        switch self {
        case .space(let n):
            return "\(n) spaces"
        case .tab(let n):
            return "\(n) tabs"
        }
    }
}
