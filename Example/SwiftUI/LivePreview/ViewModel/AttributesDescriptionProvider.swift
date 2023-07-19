//
//  AttributesDescriptionProvider.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import UIKit

struct AttributesDescriptionProvider {

    let lineLimit = NumericAttributeDescription(titleFormat: "Line limit: %.0f", range: 0...10, defaultValue: 0)
    let fontSize = NumericAttributeDescription(titleFormat: "Font size: %.0f", range: 12...40, defaultValue: 21)
    let textColor = MultiOptionAttributeDescription<UIColor?>(
        title: "Text color",
        options: [
            AttributeOption(title: "Label", value: .label),
            AttributeOption(title: "Blue", value: .systemBlue),
            AttributeOption(title: "Teal", value: .systemTeal),
            AttributeOption(title: "Green", value: .systemGreen),
            AttributeOption(title: "Orange", value: .systemOrange),
            AttributeOption(title: "Red", value: .systemRed)
        ]
    )
    let textAlignment = MultiOptionAttributeDescription<NSTextAlignment>(
        title: "Text alignment",
        options: [
            AttributeOption(title: "Natural", value: .natural),
            AttributeOption(title: "Left-aligned", value: .left),
            AttributeOption(title: "Centered", value: .center),
            AttributeOption(title: "Right-aligned", value: .right),
            AttributeOption(title: "Justified", value: .justified)
        ]
    )
}

struct MultiOptionAttributeDescription<Value: Equatable> {

    let title: String
    let options: [AttributeOption<Value>]
    let defaultValue: Value

    init(title: String, options: [AttributeOption<Value>], defaultValue: Value) {
        self.title = title
        self.options = options
        self.defaultValue = defaultValue
    }

    init(title: String, options: [AttributeOption<Value>]) {
        self.init(title: title, options: options, defaultValue: options[0].value)
    }
}

struct NumericAttributeDescription {
    let titleFormat: String
    let range: ClosedRange<Double>
    let defaultValue: Double
}
