//
//  DTTextWithHtmlProcessor.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 26/07/2023.
//

import DTCoreText

public struct DTTextWithHtmlProcessor: RichTextProcessor {

    /// DTCoreText's internal attribute for paragraph prefixes, e.g., bullet points
    private static let dtFieldAttribute = NSAttributedString.Key(DTFieldAttribute)

    public init() {
    }

    public func attributedText(from text: String, withTextColor textColor: UIColor) -> NSAttributedString? {
        guard let data = text.data(using: .utf8),
              let builder = DTHTMLAttributedStringBuilder(
                html: data,
                options: [
                    DTDefaultTextColor: textColor,
                    DTUseiOS6Attributes: true, // do not remove, otherwise app will crash
                ],
                documentAttributes: nil
              )
        else {
            return nil
        }

        let attributedText = NSMutableAttributedString(
            attributedString: builder.generatedAttributedString().trimTrailingNewlines()
        )
        /// DTCoreText adds additional paragraph spacing for <ul>/<ol> list item paragraphs.
        /// to eliminate this, we iterate through the attributes, searching for DTField attributes with a value of DTListPrefixField and reset paragraph spacing
        attributedText.enumerateAttribute(Self.dtFieldAttribute, in: attributedText.range) {
            (value, range, _) in

            guard value as? String == DTListPrefixField,
                  let paragraphStyle = attributedText.attribute(
                    .paragraphStyle,
                    at: range.location
                  ) as? NSMutableParagraphStyle
            else { return }

            paragraphStyle.paragraphSpacing = 0
            paragraphStyle.paragraphSpacingBefore = 0
        }

        return attributedText
    }
}

private extension NSAttributedString {
    func trimTrailingNewlines() -> NSAttributedString {
        let traiNewlinesRange = string.rangeOfCharacter(from: .newlines.inverted, options: .backwards)
        guard let traiNewlinesStart = traiNewlinesRange?.lowerBound else {
            return self
        }

        return attributedSubstring(from: NSRange(string.startIndex...traiNewlinesStart, in: string))
    }
}
