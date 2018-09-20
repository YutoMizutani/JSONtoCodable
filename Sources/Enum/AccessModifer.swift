//
//  AccessModifer.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public enum AccessModifer: String {
    case `default` = ""
    case `private`, `fileprivate`, `internal`, `public`, open
}
