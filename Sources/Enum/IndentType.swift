//
//  IndentType.swift
//  JSONtoCodable macOS
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import Foundation

public enum IndentType {
    case space(Int)
    case tab(Int)
}

extension IndentType {
    var rawValue: String {
        switch self {
        case .space(let v):
            return String(repeating: " ", count: v)
        case .tab(let v):
            return String(repeating: "\t", count: v)
        }
    }
}
