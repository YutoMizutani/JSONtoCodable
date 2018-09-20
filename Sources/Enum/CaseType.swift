//
//  CaseType.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum CaseType {
    /// PascalCase
    case pascal
    /// camelCase
    case camel
    /// snake_case
    case snake
    /// SCREAMING_SNAKE_CASE
    case screamingSnake
}

public extension Array where Element == String {
    func joined(with caseType: CaseType) -> String {
        switch caseType {
        case .pascal:
            return self.map { $0.capitalized }.joined()
        case .camel:
            return self.enumerated().map { $0.offset == 0 ? $0.element.lowercased() : $0.element.capitalized }.joined()
        case .snake:
            return self.map { $0.lowercased() }.joined(separator: "_")
        case .screamingSnake:
            return self.map { $0.uppercased() }.joined(separator: "_")
        }
    }
}
