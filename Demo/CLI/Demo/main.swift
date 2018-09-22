//
//  main.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/09/21.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import JSONtoCodable

let codable = JSONtoCodable()
let wait: Double = 0.05
var input: String?
var date = Date()

// MARK: - methods

/// Copyright
func copyright() {
    print("JSONtoCodable - CLI Demo")
    print("Copyright © 2018 Yuto Mizutani.")
    print("This software is released under the MIT License.")
    print()
}

/// Decision exit command
func decisionExit(_ input: String) -> Bool {
    let input = input.lowercased()
    return !["e", "-e", "exit", "exit()"].filter({ $0 == input }).isEmpty
}

/// Generate from JSON to Codable
func generate(_ input: String) {
    print("Your input:")
    print("------ ------ ------ ------ ------")
    print(input)
    print("------ ------ ------ ------ ------")
    print()

    do {
        let result = try codable.generate(input)
        print("Collect JSON format!!")
        print()
        print("Generated text:")
        print("====== ====== ====== ====== ======")
        print(result)
        print("====== ====== ====== ====== ======")
    } catch JSONError.wrongFormat {
        print("Wrong JSON format!!")
    } catch let e {
        print("An Unknown error occurred: \(e.localizedDescription)")
    }

    print()
}

// MARK: - main

copyright()
while true {
    guard input != nil else {
        print(">> ", terminator: "")
        guard let readLine = readLine() else { continue }
        input = readLine + "\n"
        date = Date()
        continue
    }

    guard let readLine = readLine() else { continue }
    if Double(Date().timeIntervalSince(date)) > wait {
        input!.append(readLine)
        let text = input!
        input = nil
        guard !decisionExit(text) else { break }
        generate(text)
    } else {
        input!.append(readLine + "\n")
    }
}
