//
//  PlainTextProcessor.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 25/07/2023.
//

import UIKit

public struct PlainTextProcessor: RichTextProcessor {

    private let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

    public init() {
    }

    public func attributedText(from text: String, withTextColor textColor: UIColor) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .paragraphStyle: NSMutableParagraphStyle()
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)

        guard let linkDetector else { return attributedText }

        let linkMatches = linkDetector.matches(in: attributedText.string, range: attributedText.range)
        for match in linkMatches {
            guard let url = match.url else { continue }
            attributedText.addAttribute(.link, value: url, range: match.range)
        }

        return attributedText
    }
}
