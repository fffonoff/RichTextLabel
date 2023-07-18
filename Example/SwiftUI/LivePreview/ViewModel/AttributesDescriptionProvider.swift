//
//  AttributesDescriptionProvider.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

struct AttributesDescriptionProvider {

    let lineLimit = NumericAttributeDescription(titleFormat: "Line limit: %.0f", range: 0...10, defaultValue: 0)
    let fontSize = NumericAttributeDescription(titleFormat: "Font size: %.0f", range: 12...40, defaultValue: 21)
}

struct NumericAttributeDescription {
    let titleFormat: String
    let range: ClosedRange<Double>
    let defaultValue: Double
}
