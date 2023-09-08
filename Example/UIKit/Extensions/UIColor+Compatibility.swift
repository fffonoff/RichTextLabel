//
//  UIColor+Compatibility.swift
//  RichTextLabelUIKit
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

    static var linkCompat: UIColor {
        if #available(iOS 13, *) {
            return .link
        }

        return .systemBlue
    }

    static var systemBackgroundCompat: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        }

        return .white
    }

    static var tertiarySystemBackgroundCompat: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        }

        return .white
    }
}
