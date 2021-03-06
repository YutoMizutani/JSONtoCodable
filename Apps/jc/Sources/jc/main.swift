//
//  main.swift
//  jc
//
//  Created by Yuto Mizutani on 2018/09/21.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import JSONtoCodable

let codable = JSONtoCodable()
let argv = ProcessInfo.processInfo.arguments

let args = Array(argv[1..<argv.count])
for (i, e) in args.enumerated() {
    switch e {

    case "-h", "help":
        if i + 1 < args.count {
            helpCommand(args[i + 1])
        } else {
            help()
        }
        exit(EXIT_SUCCESS)

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
        print("Error: Unknown command: \(e)")
        exit(EXIT_FAILURE)
        break
    }
}

if let input = String(data: FileHandle.standardInput.availableData, encoding: .utf8) {
    do {
        let result = try codable.generate(input)
        print(result)
        exit(EXIT_SUCCESS)
    } catch JSONError.wrongFormat {
        print("Wrong JSON format!!")
        exit(EXIT_FAILURE)
    } catch let e {
        print(e.localizedDescription)
        exit(EXIT_FAILURE)
    }
}
