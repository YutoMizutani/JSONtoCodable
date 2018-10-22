//
//  main.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/09/21.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import JSONtoCodable

let codable = JSONtoCodable()

let args = ProcessInfo.processInfo.arguments
for (i, e) in args.enumerated() {
    switch e {
    // Struct name
    case "-n", "--name":
        if i + 1 < args.count {
            codable.config.name = args[i + 1]
        }
    // AccessModifier
    case "-a", "--access-modifier":
        if i + 1 < args.count,
            let accessModifier = AccessModifier(args[i + 1]) {
            codable.config.accessModifier = accessModifier
        }
    // caseType: variable
    case "-cv", "--case-variable":
        if i + 1 < args.count,
            let caseVariable = CaseType(args[i + 1]) {
            codable.config.caseType.variable = caseVariable
        }
    // CaseType: struct
    case "-cs", "--case-struct":
        if i + 1 < args.count,
            let caseStruct = CaseType(args[i + 1]) {
                codable.config.caseType.struct = caseStruct
        }
    // LineType
    case "-l", "--line-type":
        if i + 1 < args.count,
            let lineType = LineType(args[i + 1]) {
            codable.config.lineType = lineType
        }
    // IndentType
    case "-i", "--indent-type":
        if i + 1 < args.count,
            let indentType = IndentType(args[i + 1]) {
            codable.config.indentType = indentType
        }
    default:
        break
    }
}

if let input = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
    do {
        let result = try codable.generate(input)
        print(result)
    } catch JSONError.wrongFormat {
        print("Wrong JSON format!!")
    } catch let e {
        print(e.localizedDescription)
    }
}
