//
//  LineType.swift
//  JSONtoCodable
//
//  Created by Yuto Mizutani on 2018/09/20.
//

import Foundation

public enum LineType: String {
    /// \n
    case lineFeed = "\n"
    /// \r
    case carriageReturn = "\r"
    /// \r\n
    case both = "\r\n"
}
