# JSONtoCodable

[![Build Status](https://app.bitrise.io/app/869daca1801a29aa/status.svg?token=9lhf2DEdWQhg6AUaUqGXAA&branch=develop)](https://app.bitrise.io/app/869daca1801a29aa)
[![CocoaPods](https://img.shields.io/cocoapods/p/JSONtoCodable.svg)](https://github.com/YutoMizutani/JSONtoCodable)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/YutoMizutani/JSONtoCodable/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/JSONtoCodable.svg)](https://github.com/YutoMizutani/JSONtoCodable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/YutoMizutani/JSONtoCodable)

**JSONtoCodable** is a generating tool from Raw JSON to Codable (Swift4) text written in Swift4.

![demo_macos.png](https://raw.githubusercontent.com/YutoMizutani/JSONtoCodable/media/media/demo_macos.png)

## TL;DR

From JSON,

```json
{
    "user": {
        "Name": "Yuto Mizutani"
    }
    "lib": {
        "lib-name": "JSONtoCodable"
        "year": 2018
        "version": "1.0.2"
        "released": "2018-09-22"
    }
    "text": "Hello, world!!"
}
```

To Codable.

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

## Translations

|JSON Value|Swift Type|
|:-:|:-:|
|"text"|String|
|true|Bool|
|0|Int|
|1.0|Double|
|any|Any|
|null|Any?|

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