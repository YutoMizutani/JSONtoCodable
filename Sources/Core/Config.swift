//
//  Config.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public struct Config {
    public var name: String = "Result"
    public var accessModifer: AccessModifer = .default
    public var caseType: (`struct`: CaseType, variable: CaseType) = (.pascal, .camel)
    public var lineType: LineType = .lineFeed
    public var indentType: IndentType = .space(4)
}
