//
//  UIColor+Extension.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 20/07/2023.
//

import UIKit

// MARK: - UIColor+Compatibility

extension UIColor {
    static var linkCompat: UIColor {
        if #available(iOS 13, *) {
            return .link
        }

        return .systemBlue
    }
}

// MARK: - UIColor+Hex

extension UIColor {
    var hexString: String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        if components.count >= 4 {
            let a = Float(components[3])
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)
            )
        }

        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
