//
//  UIColor+Compatibility.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 14/07/2023.
//

import UIKit

extension UIColor {
    static var labelCompat: UIColor {
        if #available(iOS 13, *) {
            return .label
        }

        return .black
    }

    static var systemBackgroundCompat: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }

        return .white
    }
}
