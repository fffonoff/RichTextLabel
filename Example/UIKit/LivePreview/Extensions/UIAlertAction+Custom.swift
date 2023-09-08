//
//  UIAlertAction+Custom.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 19/07/2023.
//

import UIKit

extension UIAlertAction {
    var isChecked: Bool {
        get { value(forKey: "checked") as? Bool ?? false }
        set { setValue(newValue, forKey: "checked") }
    }

    var titleTextColor: UIColor? {
        get { value(forKey: "titleTextColor") as? UIColor }
        set { setValue(newValue, forKey: "titleTextColor") }
    }
}
