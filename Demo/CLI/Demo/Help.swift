//
//  Help.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import JSONtoCodable

func help() {
    print("""
        jc - JSONtoCodable
        Usage: jc [options]
                JSONtoCodable is a generating tool from Raw JSON to Codable output.

        Options:
                --name, -n                  Output struct name
                --access-modifier, -a       Access modifer
                --case-variable, -cv        Case type for variable
                --case-struct, -cs          Case type for struct
                --line-type, -l             Line type
                --indent-type, -i           Indent type

        Further help:
                jc help [OPTION]
        """)
}


func helpCommand(_ command: String) {
    let defaultConfig = JSONtoCodable().config

    switch command {

    // Help
    case "-h", "help":
        help()
        exit(EXIT_SUCCESS)

    // Struct name
    case "-n", "--name":
        print("""
            jc \(command) formula
                    Output the name top of struct
                    The default is `\(defaultConfig.name)`

            EXAMPLE:
                    jc \(command) Hello

            OUTPUT:
                    struct Hello: Codable { ... }
            """)

    // AccessModifier
    case "-a", "--access-modifier":
        print("""
            jc \(command) formula
                    Output the access modifer
                    The default is `\(defaultConfig.accessModifier.parameterString)`

            PARAMETERS:
                    default, d          DEFAULT (empty)
                    private, pr         private
                    fileprivate, f      fileprivate
                    internal, i         internal
                    public, pu          public
                    open, o             open

            EXAMPLE:
                    jc \(command) private

            OUTPUT:
                    private struct \(defaultConfig.name): Codable { ... }
            """)

    // caseType: variable
    case "-cv", "--case-variable":
        print("""
            jc \(command) formula
                    Output case pattern for variables
                    The default is `\(defaultConfig.caseType.variable.parameterString)`

            PARAMETERS:
                    pascal, p           PascalCase
                    camel, c            camelCase
                    snake, sn           snake_case
                    screaming-snake, ss SCREAMING_SNAKE_CASE

            EXAMPLE:
                    jc \(command) camel

            OUTPUT:
                    struct \(defaultConfig.name): Codable {
                        var exampleString: String
                    }
            """)

    // CaseType: struct
    case "-cs", "--case-struct":
        print("""
            jc \(command) formula
                    Output case pattern for structs
                    The default is `\(defaultConfig.caseType.struct.parameterString)`

            PARAMETERS:
                    pascal, p           PascalCase
                    camel, c            camelCase
                    snake, sn           snake_case
                    screaming-snake, ss SCREAMING_SNAKE_CASE

            EXAMPLE:
                    jc \(command) screaming-snake

            OUTPUT:
                    struct \([defaultConfig.name].joined(with: .screamingSnake)): Codable { ... }
            """)

    // LineType
    case "-l", "--line-type":
        print("""
            jc \(command) formula
                    Output line type
                    The default is `\(defaultConfig.lineType.parameterString)`

            PARAMETERS:
                    line-feed, \\n, n           Line feed (LF)
                    carriage-return, \\r, r     Carriage return (CR)
                    both, \\r\\n, rn            Both (CRLF)

            EXAMPLE:
                    jc \(command) carriage-return

            OUTPUT:
                    struct \(defaultConfig.name): Codable {\\r ... \\r}
            """)

    // IndentType
    case "-i", "--indent-type":
        print("""
            jc \(command) formula
                    Output indent type
                    The default is `\(defaultConfig.indentType.parameterString)`

            PARAMETERS:
                    sX       Spaces X times
                    tX       Tabs X times

            EXAMPLE:
                    jc \(command) t4

            OUTPUT:
                    struct \([defaultConfig.name].joined(with: .screamingSnake)): Codable {
                    \\t\\t\\t\\tvar exampleString: String
                    }
            """)

    default:
        print("Error: Unknown command: \(command)")
        exit(EXIT_FAILURE)
    }
}

