//
//  UIAlertAction+Custom.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 19/07/2023.
//

import UIKit

extension UIAlertAction {
    convenience init(title: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: .default, handler: handler)
    }

    var titleTextColor: UIColor? {
        get { value(forKey: "titleTextColor") as? UIColor }
        set { setValue(newValue, forKey: "titleTextColor") }
    }

    var isChecked: Bool {
        get { value(forKey: "checked") as? Bool ?? false }
        set { setValue(newValue, forKey: "checked") }
    }
}
