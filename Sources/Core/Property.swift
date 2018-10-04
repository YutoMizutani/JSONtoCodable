//
//  Property.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

class Property: Equatable {
    var prefix: String
    var immutables: [String] = []
    var structs: [String] = []
    var codingKeys: [String] = []
    let suffix: String?

    init(_ key: String, accessModifier accessModifierType: AccessModifier = .default) {
        let accessModifier: String = accessModifierType == .default ? "" : "\(accessModifierType.rawValue) "
        self.prefix = "\(accessModifier)struct \(key): Codable {"
        self.suffix = "}"
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        return
            lhs.prefix == rhs.prefix &&
            lhs.immutables == rhs.immutables &&
            lhs.structs == rhs.structs &&
            lhs.codingKeys == rhs.codingKeys &&
            lhs.suffix == rhs.suffix
    }
}
