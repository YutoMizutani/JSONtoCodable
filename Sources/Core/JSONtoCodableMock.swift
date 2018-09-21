//
//  JSONtoCodableMock.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/21.
//

import Foundation

public class JSONtoCodableMock {
    typealias Property = (prefix: String, suffix: String?)
    typealias Register = (isString: Bool, value: String)
    typealias ImmutableSeed = (key: String, type: Type)

    enum TranslateState {
        case prepareKey, inKey, prepareValue, inValue, inArray(Any)
    }

    public var config: Config = Config()
}

extension JSONtoCodableMock {
    func decisionType(value: String, isString: Bool) -> Type {
        return .any
    }
}
