//
//  TranslateState.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import Foundation

public enum TranslateState {
    case prepareKey, inKey, prepareValue, inValue, inArray(Any)
}
