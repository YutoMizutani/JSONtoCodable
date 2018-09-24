//
//  Property.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

class Property: Equatable {
    let prefix: String
    var immutables: [String] = []
    var structs: [String] = []
    var codingKeys: [String] = []
    let suffix: String?

    init(_ key: String, accessModifer accessModiferType: AccessModifer = .default) {
        let accessModifer: String = accessModiferType == .default ? "" : "\(accessModiferType.rawValue) "
        self.prefix = "\(accessModifer)struct \(key): Codable {"
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
