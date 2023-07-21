//
//  UIColor+Compatibility.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 20/07/2023.
//

import UIKit

extension UIColor {
    static var linkCompat: UIColor {
        if #available(iOS 13, *) {
            return .link
        }

        return .systemBlue
    }
}
