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

    case stringArray
    case boolArray
    case intArray
    case doubleArray
    case anyArray
    case structArray(String)

    case optionalString
    case optionalBool
    case optionalInt
    case optionalDouble
    case optionalAny
    case optionalStruct(String)

    case optionalStringArray
    case optionalBoolArray
    case optionalIntArray
    case optionalDoubleArray
    case optionalAnyArray
    case optionalStructArray(String)
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

        case .stringArray:
            return "[\(Type.string.rawValue)]"
        case .boolArray:
            return "[\(Type.bool.rawValue)]"
        case .intArray:
            return "[\(Type.int.rawValue)]"
        case .doubleArray:
            return "[\(Type.double.rawValue)]"
        case .anyArray:
            return "[\(Type.any.rawValue)]"
        case .structArray(let v):
            return "[\(Type.struct(v).rawValue)]"

        case .optionalStringArray:
            return "\(Type.stringArray.rawValue)?"
        case .optionalBoolArray:
            return "\(Type.boolArray.rawValue)?"
        case .optionalIntArray:
            return "\(Type.intArray.rawValue)?"
        case .optionalDoubleArray:
            return "\(Type.doubleArray.rawValue)?"
        case .optionalAnyArray:
            return "\(Type.anyArray.rawValue)?"
        case .optionalStructArray(let v):
            return "\(Type.structArray(v).rawValue)?"
        }
    }

    var isOptional: Bool {
        return self.hashValue >= Type.optionalString.hashValue
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

        case .stringArray, .optionalStringArray:
            return .optionalStringArray
        case .boolArray, .optionalBoolArray:
            return .optionalBoolArray
        case .intArray, .optionalIntArray:
            return .optionalIntArray
        case .doubleArray, .optionalDoubleArray:
            return .optionalDoubleArray
        case .anyArray, .optionalAnyArray:
            return .optionalAnyArray
        case .structArray(let v), .optionalStructArray(let v):
            return .optionalStructArray(v)
        }
    }
}

public extension Array where Element == Type {
    func unique() -> [Type] {
        return Array(Set(self))
    }

    func hasOptional() -> Bool {
        return self.filter({ !$0.isOptional }).isEmpty
    }

    func sumType() -> Type {
        let types: [Type] = self.unique()
        switch types.count {
        case 0:
            return .optionalAny
        case 1:
            return types[0]
        case 2:
            if types[0].hashValue < Type.optionalString.hashValue &&
                types[1].hashValue - types[0].hashValue == Type.optionalString.hashValue {
                return types[1]
            } else {
                fallthrough
            }
        default:
            return self.hasOptional() ? Type.optionalAnyArray : Type.anyArray
        }
    }
}
