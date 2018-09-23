//
//  Type.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import Foundation

public enum Type: Hashable {
    case string
    case bool
    case int
    case double
    case any
    case `struct`(String)

    case optionalString
    case optionalBool
    case optionalInt
    case optionalDouble
    case optionalAny
    case optionalStruct(String)
}

public extension Type {
    var rawValue: String {
        switch self {
        case .string:
            return "String"
        case .bool:
            return "Bool"
        case .int:
            return "Int"
        case .double:
            return "Double"
        case .any:
            return "Any"
        case .struct(let v):
            return v

        case .optionalString:
            return "\(Type.string.rawValue)?"
        case .optionalBool:
            return "\(Type.bool.rawValue)?"
        case .optionalInt:
            return "\(Type.int.rawValue)?"
        case .optionalDouble:
            return "\(Type.double.rawValue)?"
        case .optionalAny:
            return "\(Type.any.rawValue)?"
        case .optionalStruct(let v):
            return "\(Type.struct(v).rawValue)?"
        }
    }

    func optional() -> Type {
        switch self {
        case .string, .optionalString:
            return .optionalString
        case .bool, .optionalBool:
            return .optionalBool
        case .int, .optionalInt:
            return .optionalInt
        case .double, .optionalDouble:
            return .optionalDouble
        case .any, .optionalAny:
            return .optionalAny
        case .struct(let v), .optionalStruct(let v):
            return .optionalStruct(v)
        }
    }
}
