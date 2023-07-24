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
    let lineHeightMultiplier = NumericAttributeDescription(
        titleFormat: "Line height: %.2f",
        range: 1...2,
        step: 0.05,
        defaultValue: 1
    )

    let linksDecorationsGroupTitle = "Links decorations"
    let linkTextColor = MultiOptionAttributeDescription<UIColor?>(
        title: "Link color",
        options: [
            AttributeOption(title: "Default", value: .link),
            AttributeOption(title: "Primary", value: .label),
            AttributeOption(title: "Teal", value: .systemTeal),
            AttributeOption(title: "Green", value: .systemGreen),
            AttributeOption(title: "Orange", value: .systemOrange),
            AttributeOption(title: "Red", value: .systemRed)
        ]
    )
    let linkHighlightColor = MultiOptionAttributeDescription<UIColor?>(
        title: "Highlight color",
        options: [
            AttributeOption(title: "Default", value: UIColor(red: 0.68, green: 0.85, blue: 0.9, alpha: 0.35)),
            AttributeOption(title: "None", value: nil),
            AttributeOption(title: "Blue", value: .systemBlue.withAlphaComponent(0.2)),
            AttributeOption(title: "Teal", value: .systemTeal.withAlphaComponent(0.2)),
            AttributeOption(title: "Green", value: .systemGreen.withAlphaComponent(0.2)),
            AttributeOption(title: "Orange", value: .systemOrange.withAlphaComponent(0.2))
        ]
    )
    let linkHighlightCornerRadius = NumericAttributeDescription(
        titleFormat: "Highlight corner radius: %.0f",
        range: 0...12,
        defaultValue: 6
    )
    let linkUnderlineType = MultiOptionAttributeDescription<NSUnderlineStyle>(
        title: "Underline type",
        options: [
            AttributeOption(title: "Single", value: .single),
            AttributeOption(title: "Thick", value: .thick),
            AttributeOption(title: "Double", value: .double),
            AttributeOption(title: "None", value: [])
        ]
    )
    let linkUnderlinePattern = MultiOptionAttributeDescription<NSUnderlineStyle>(
        title: "Underline pattern",
        options: [
            AttributeOption(title: "Line", value: []),
            AttributeOption(title: "Pattern dot", value: .patternDot),
            AttributeOption(title: "Pattern dash", value: .patternDash),
            AttributeOption(title: "Pattern dash dot", value: .patternDashDot),
            AttributeOption(title: "Pattern dash dot dot", value: .patternDashDotDot)
        ]
    )
    let persistentUnderline = BooleanAttributeDescription(title: "Persistent underline", defaultValue: true)
    let underlineByWord = BooleanAttributeDescription(title: "Underline by word", defaultValue: false)

    let textShadowGroupTitle = "Text shadow"
    let shadowColor = MultiOptionAttributeDescription<UIColor?>(
        title: "Text shadow color",
        options: [
            AttributeOption(title: "None", value: nil),
            AttributeOption(title: "Label", value: .label.withAlphaComponent(0.3)),
            AttributeOption(title: "Gray", value: .systemGray.withAlphaComponent(0.3)),
            AttributeOption(title: "Orange", value: .systemOrange.withAlphaComponent(0.3))
        ]
    )
    let shadowXOffset = NumericAttributeDescription(
        titleFormat: "Shadow xOffset: %.0f",
        range: -1...4,
        defaultValue: 1
    )
    let shadowYOffset = NumericAttributeDescription(
        titleFormat: "Shadow yOffset: %.0f",
        range: -2...4,
        defaultValue: 1
    )
}

struct BooleanAttributeDescription {
    let title: String
    let defaultValue: Bool
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
    var step: Double = 1
    let defaultValue: Double
}
