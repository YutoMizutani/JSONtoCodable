//
//  NSTextView+.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/10/25.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Cocoa

extension NSTextView {
    override open func paste(_ sender: Any?) {
        // Ignore text format
        pasteAsPlainText(sender)
    }
}
