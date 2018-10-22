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
    case "-name", "-n":
        if i + 1 < args.count {
            codable.config.name = args[i + 1]
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
