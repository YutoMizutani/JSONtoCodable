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
    var order: Int {
        switch self {
        case .string:
            return 0
        case .bool:
            return 1
        case .int:
            return 2
        case .double:
            return 3
        case .any:
            return 4
        case .struct:
            return 5

        case .stringArray:
            return 6
        case .boolArray:
            return 7
        case .intArray:
            return 8
        case .doubleArray:
            return 9
        case .anyArray:
            return 10
        case .structArray:
            return 11

        case .optionalString:
            return 12
        case .optionalBool:
            return 13
        case .optionalInt:
            return 14
        case .optionalDouble:
            return 15
        case .optionalAny:
            return 16
        case .optionalStruct:
            return 17

        case .optionalStringArray:
            return 18
        case .optionalBoolArray:
            return 19
        case .optionalIntArray:
            return 20
        case .optionalDoubleArray:
            return 21
        case .optionalAnyArray:
            return 22
        case .optionalStructArray:
            return 23
        }
    }

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

        case .optionalStringArray:
            return "[\(Type.optionalString.rawValue)]"
        case .optionalBoolArray:
            return "[\(Type.optionalBool.rawValue)]"
        case .optionalIntArray:
            return "[\(Type.optionalInt.rawValue)]"
        case .optionalDoubleArray:
            return "[\(Type.optionalDouble.rawValue)]"
        case .optionalAnyArray:
            return "[\(Type.optionalAny.rawValue)]"
        case .optionalStructArray(let v):
            return "[\(Type.optionalStruct(v).rawValue)]"
        }
    }

    var isOptional: Bool {
        return self.order >= Type.optionalString.order
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

    func toArray() -> Type {
        switch self {
        case .string, .stringArray:
            return .stringArray
        case .bool, .boolArray:
            return .boolArray
        case .int, .intArray:
            return .intArray
        case .double, .doubleArray:
            return .doubleArray
        case .any, .anyArray:
            return .anyArray
        case .struct(let v), .structArray(let v):
            return .structArray(v)

        case .optionalString, .optionalStringArray:
            return .optionalStringArray
        case .optionalBool, .optionalBoolArray:
            return .optionalBoolArray
        case .optionalInt, .optionalIntArray:
            return .optionalIntArray
        case .optionalDouble, .optionalDoubleArray:
            return .optionalDoubleArray
        case .optionalAny, .optionalAnyArray:
            return .optionalAnyArray
        case .optionalStruct(let v), .optionalStructArray(let v):
            return .optionalStructArray(v)
        }
    }
}

public extension Array where Element == Type {
    func unique() -> [Type] {
        return Array(Set(self)).sorted(by: { $0.order < $1.order })
    }

    func hasOptional() -> Bool {
        return !self.filter({ $0.isOptional }).isEmpty
    }

    func sumType() -> Type {
        let types: [Type] = self.unique()
        switch types.count {
        case 0:
            return .optionalAnyArray
        case 1:
            return types[0].toArray()
        case 2:
            if types[0].order < Type.optionalString.order &&
                types[1].order - types[0].order == Type.optionalString.order {
                return types[1].toArray()
            } else {
                fallthrough
            }
        default:
            return self.hasOptional() ? Type.optionalAnyArray : Type.anyArray
        }
    }
}
