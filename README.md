# JSONtoCodable

[![Build Status](https://app.bitrise.io/app/869daca1801a29aa/status.svg?token=9lhf2DEdWQhg6AUaUqGXAA&branch=develop)](https://app.bitrise.io/app/869daca1801a29aa)
[![CocoaPods](https://img.shields.io/cocoapods/p/JSONtoCodable.svg)](https://github.com/YutoMizutani/JSONtoCodable)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/YutoMizutani/JSONtoCodable/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/JSONtoCodable.svg)](https://github.com/YutoMizutani/JSONtoCodable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/YutoMizutani/JSONtoCodable)
[![codecov](https://codecov.io/gh/YutoMizutani/JSONtoCodable/branch/master/graph/badge.svg)](https://codecov.io/gh/YutoMizutani/JSONtoCodable)

**JSONtoCodable** is a generating tool from Raw JSON to Codable (Swift4) text written in Swift4.

![demo_macos.png](https://raw.githubusercontent.com/YutoMizutani/JSONtoCodable/media/media/demo_macos.png)

## TL;DR

From JSON,

```json
{
    "user": {
        "Name": "Yuto Mizutani"
    },
    "lib": {
        "lib-name": "JSONtoCodable",
        "year": 2018,
        "version": "1.0.2",
        "released": "2018-09-22"
    },
    "text": "Hello, world!!"
}
```

to Codable.

```swift
public struct Result: Codable {
    public let user: User
    public let lib: Lib
    public let text: String

    public struct User: Codable {
        public let name: String

        private enum CodingKeys: String, CodingKey {
            case name = "Name"
        }
    }

    public struct Lib: Codable {
        public let libName: String
        public let year: Int
        public let version: String
        public let released: String

        private enum CodingKeys: String, CodingKey {
            case libName = "lib-name"
            case year
            case version
            case released
        }
    }
}
```

## Demo

- [macOS demo](https://github.com/YutoMizutani/JSONtoCodable/tree/master/Demo/macOS)

![demo_macos.png](https://raw.githubusercontent.com/YutoMizutani/JSONtoCodable/media/media/demo_macos.png)

- [CLI demo](https://github.com/YutoMizutani/JSONtoCodable/tree/master/Demo/CLI)

![demo_cli.png](https://raw.githubusercontent.com/YutoMizutani/JSONtoCodable/media/media/demo_cli.png)

## Support formats

- Type
	- String
	- Bool
	- Int
	- Double
	- struct(s)
	- Optional<T>
- Array
	- Start array
	- Muptiple array
	- Arrayed objects
	- Optional array
- Number of nested array and objects
	- Infinity
- Number of spaces in entered JSON
	- 0 to infinity

## Translations

|JSON Value|Swift Type|
|:-:|:-:|
|"text"|String|
|true|Bool|
|-10|Int|
|1.0|Double|
|null|\<Foo\>?|
|(the others)|Any|

## Usage

```swift
import JSONtoCodable

let json: String = """
{
    "Hello": "Hello, world!!"
}
"""

let jsonToCodable = JSONtoCodable()
let codable = try? jsonToCodable.generate(json)

print(codable)
/*
struct Result: Codable {
    let hello: String

    private enum CodingKeys: String, CodingKey {
        case hello = "Hello"
    }
}
*/
```

## Config

```swift
let config = Config()
config.name = "Result" // struct Result: Codable {}
config.accessModifer = AccessModifer.public // public struct
config.caseType = (variable: CaseType.camel, struct: CaseType.pascal)
config.lineType = LineType.lineFeed
config.indentType = IndentType.space(4)
```

[See more: Config.swift](https://github.com/YutoMizutani/JSONtoCodable/blob/master/Sources/Core/Config.swift)

## Installation

#### Cocoapods

Add this to your Podfile:

```
pod 'JSONtoCodable'
```

and

```
$ pod install
```

#### Carthage

Add this to your Cartfile:

```
github "YutoMizutani/JSONtoCodable"
```

and

```
$ carthage update
```

## License

JSONtoCodable is available under the [MIT license](https://github.com/YutoMizutani/JSONtoCodable/blob/master/LICENSE).