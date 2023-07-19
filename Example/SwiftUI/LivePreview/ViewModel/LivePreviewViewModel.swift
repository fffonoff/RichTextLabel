//
//  LivePreviewViewModel.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import SwiftUI

final class LivePreviewViewModel: ObservableObject {

    let attributes = AttributesDescriptionProvider()

    let text = """
    RichTextLabel supports all UILabel functionality as well as custom link handling: https://github.com/fffonoff/RichTextLabel
    """

    @Published var lineNumber: Double
    @Published var fontSize: Double
    @Published var textColor: UIColor?
    @Published var textAlignment: NSTextAlignment

    @Published var shadowColor: UIColor?
    @Published var shadowXOffset: Double
    @Published var shadowYOffset: Double

    init() {
        lineNumber = attributes.lineLimit.defaultValue
        fontSize = attributes.fontSize.defaultValue
        textColor = attributes.textColor.defaultValue
        textAlignment = attributes.textAlignment.defaultValue

        shadowColor = attributes.shadowColor.defaultValue
        shadowXOffset = attributes.shadowXOffset.defaultValue
        shadowYOffset = attributes.shadowYOffset.defaultValue
    }
}
