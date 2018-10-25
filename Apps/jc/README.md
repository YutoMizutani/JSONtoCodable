# jc

A generating tool from Raw **JSON to Codable** output application *JSONtoCodable* for CLI.

#### Current version: 2.1.1 [[Download](https://github.com/YutoMizutani/JSONtoCodable/releases/download/2.1.1/jc.zip)] or [brew install](https://github.com/YutoMizutani/JSONtoCodable/tree/master/Apps/jc#installation)

![demo_cli.png](https://raw.githubusercontent.com/YutoMizutani/JSONtoCodable/media/media/demo_cli.png)

## Installation

```
$ brew tap YutoMizutani/jc
$ brew install jc
```

## Usage example

```
$ curl https://httpbin.org/get | jc
```

or generate *.swift* file,

```
$ curl https://httpbin.org/get | jc > Result.swift
```

## Help command

```
$ jc -h
```

## License

JSONtoCodable and jc is available under the [MIT license](https://github.com/YutoMizutani/JSONtoCodable/blob/master/LICENSE).
