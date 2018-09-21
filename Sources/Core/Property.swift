//
//  Property.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

class Property {
    let prefix: String
    var structs: [String] = []
    var immutables: [String] = []
    var codingKeys: [String] = []
    let suffix: String?

    init(_ key: String, accessModifer accessModiferType: AccessModifer = .default) {
        let accessModifer: String = accessModiferType == .default ? "" : "\(accessModiferType.rawValue) "
        self.prefix = "\(accessModifer)struct \(key): Codable {"
        self.suffix = "}"
    }
}
