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

    case stringOptionalArray
    case boolOptionalArray
    case intOptionalArray
    case doubleOptionalArray
    case anyOptionalArray
    case structOptionalArray(String)
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

        case .stringOptionalArray:
            return 18
        case .boolOptionalArray:
            return 19
        case .intOptionalArray:
            return 20
        case .doubleOptionalArray:
            return 21
        case .anyOptionalArray:
            return 22
        case .structOptionalArray:
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

        case .stringOptionalArray:
            return "[\(Type.optionalString.rawValue)]"
        case .boolOptionalArray:
            return "[\(Type.optionalBool.rawValue)]"
        case .intOptionalArray:
            return "[\(Type.optionalInt.rawValue)]"
        case .doubleOptionalArray:
            return "[\(Type.optionalDouble.rawValue)]"
        case .anyOptionalArray:
            return "[\(Type.optionalAny.rawValue)]"
        case .structOptionalArray(let v):
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

        case .stringArray, .stringOptionalArray:
            return .stringOptionalArray
        case .boolArray, .boolOptionalArray:
            return .boolOptionalArray
        case .intArray, .intOptionalArray:
            return .intOptionalArray
        case .doubleArray, .doubleOptionalArray:
            return .doubleOptionalArray
        case .anyArray, .anyOptionalArray:
            return .anyOptionalArray
        case .structArray(let v), .structOptionalArray(let v):
            return .structOptionalArray(v)
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

        case .optionalString, .stringOptionalArray:
            return .stringOptionalArray
        case .optionalBool, .boolOptionalArray:
            return .boolOptionalArray
        case .optionalInt, .intOptionalArray:
            return .intOptionalArray
        case .optionalDouble, .doubleOptionalArray:
            return .doubleOptionalArray
        case .optionalAny, .anyOptionalArray:
            return .anyOptionalArray
        case .optionalStruct(let v), .structOptionalArray(let v):
            return .structOptionalArray(v)
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
            return .anyOptionalArray
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
            return self.hasOptional() ? Type.anyOptionalArray : Type.anyArray
        }
    }
}
