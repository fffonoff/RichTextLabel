//
//  NSAttributedString+Helper.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 20/07/2023.
//

import Foundation

extension NSAttributedString {

    var range: NSRange { NSRange(location: 0, length: length) }

    func attribute(_ attrName: NSAttributedString.Key, at location: Int) -> Any? {
        return attribute(attrName, at: location, effectiveRange: nil)
    }
}

extension NSMutableAttributedString {
    func addFullRangeAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: range)
    }
}
