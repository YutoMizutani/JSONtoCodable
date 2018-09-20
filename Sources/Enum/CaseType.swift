//
//  CaseType.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum CaseType {
    /// UPPER_CASE
    case upper
    /// PascalCase
    case pascal
    /// camelCase
    case camel
    /// snake_case
    case snake
}

public extension Array where Element == String {
    func joined(with caseType: CaseType) -> String {
        switch caseType {
        case .upper:
            return self.map { $0.uppercased() }.joined(separator: "_")
        case .pascal:
            return self.map { $0.capitalized }.joined()
        case .camel:
            return self.enumerated().map { $0.offset == 0 ? $0.element.lowercased() : $0.element.capitalized }.joined()
        case .snake:
            return self.map { $0.lowercased() }.joined(separator: "_")
        }
    }
}
