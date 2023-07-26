//
//  TextWithHtmlProcessor.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 25/07/2023.
//

import UIKit

public struct TextWithHtmlProcessor: RichTextProcessor {

    public var requiresAsyncTextProcessing = true

    /// Hex string of placeholder color to be replaced with desired one
    ///
    /// We utilize color that is unlikely to occur in real-life scenarios to prevent collisions with user-specified CSS color styling
    private static let placeholderColorHex = UIColor.magenta.withAlphaComponent(0.01).hexString ?? "#FF00FF03"

    public init() {
    }

    public func attributedText(from text: String, withTextColor textColor: UIColor) -> NSAttributedString? {
        /// System HTML importer uses plain black text color if other isn't specified with CSS styling.
        /// As a workaround, we apply text color through CSS as a placeholder
        /// and later replace `.foregroundColor` attributes that have that placeholder color with desired one.
        /// This allows to keep any CSS color styling from the original text
        let coloredText = "<style>body{color:\(Self.placeholderColorHex);}</style>\(text)"
        let encoding = String.Encoding.utf8
        guard let textData = coloredText.data(using: encoding),
              let attributedText = try? NSMutableAttributedString(
                data: textData,
                options: [.characterEncoding: encoding.rawValue, .documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
              )
        else {
            return nil
        }

        attributedText.enumerateAttribute(.foregroundColor, in: attributedText.range) { value, range, _ in
            guard let colorValue = value as? UIColor, colorValue.hexString == Self.placeholderColorHex else { return }

            attributedText.addAttribute(.foregroundColor, value: textColor, range: range)
        }

        return attributedText
    }

    public func update(textColor: UIColor, oldValue: UIColor?, in attributedText: NSMutableAttributedString) {
        var hasTextColorAttribute = false
        attributedText.enumerateAttribute(.foregroundColor, in: attributedText.range) { value, range, _ in
            guard let color = value as? UIColor else { return }

            hasTextColorAttribute = true
            guard color == oldValue || color.hexString == Self.placeholderColorHex else { return }

            attributedText.addAttribute(.foregroundColor, value: textColor, range: range)
        }

        if !hasTextColorAttribute {
            attributedText.addFullRangeAttribute(.foregroundColor, value: textColor)
        }
    }
}
