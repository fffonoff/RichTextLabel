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

    public func update(font: UIFont, in attributedText: NSMutableAttributedString) {
        var hasFontAttribute = false
        attributedText.enumerateAttribute(.font, in: attributedText.range) { value, range, _ in
            guard let fontAttribute = value as? UIFont,
                  let descriptor = font.fontDescriptor.withSymbolicTraits(fontAttribute.fontDescriptor.symbolicTraits)
            else { return }

            let correctFont = UIFont(descriptor: descriptor, size: font.pointSize)
            attributedText.addAttribute(.font, value: correctFont, range: range)
            hasFontAttribute = true
        }

        if !hasFontAttribute {
            attributedText.addFullRangeAttribute(.font, value: font)
        }
    }

    public func update(textColor: UIColor, oldValue: UIColor?, in attributedText: NSMutableAttributedString) {
        var hasTextColorAttribute = false
        attributedText.enumerateAttribute(.foregroundColor, in: attributedText.range) { value, range, _ in
            guard let color = value as? UIColor else { return }

            hasTextColorAttribute = true
            guard color == oldValue else { return }

            attributedText.addAttribute(.foregroundColor, value: textColor, range: range)
        }

        if !hasTextColorAttribute {
            attributedText.addFullRangeAttribute(.foregroundColor, value: textColor)
        }
    }

    public func update(textAlignment: NSTextAlignment, in attributedText: NSMutableAttributedString) {
        var paragraphAttributes: [(range: NSRange, style: NSMutableParagraphStyle)] = []
        attributedText.enumerateAttribute(.paragraphStyle, in: attributedText.range) { value, range, _ in
            guard let paragraphStyle = value as? NSMutableParagraphStyle else { return }

            paragraphAttributes.append((range: range, style: paragraphStyle))
        }

        paragraphAttributes.forEach { attribute in
            attribute.style.alignment = textAlignment
            attributedText.addAttribute(.paragraphStyle, value: attribute.style, range: attribute.range)
        }
    }

    public func update(
        lineBreakStrategy: NSParagraphStyle.LineBreakStrategy,
        in attributedText: NSMutableAttributedString
    ) {
        var paragraphAttributes: [(range: NSRange, style: NSMutableParagraphStyle)] = []
        attributedText.enumerateAttribute(.paragraphStyle, in: attributedText.range) { value, range, _ in
            guard let paragraphStyle = value as? NSMutableParagraphStyle else { return }

            paragraphAttributes.append((range: range, style: paragraphStyle))
        }

        paragraphAttributes.forEach { attribute in
            attribute.style.lineBreakStrategy = lineBreakStrategy
            attributedText.addAttribute(.paragraphStyle, value: attribute.style, range: attribute.range)
        }
    }

    public func update(lineHeightMultiplier: CGFloat, in attributedText: NSMutableAttributedString) {
        var paragraphAttributes: [(range: NSRange, style: NSMutableParagraphStyle)] = []
        attributedText.enumerateAttribute(.paragraphStyle, in: attributedText.range) { value, range, _ in
            guard let paragraphStyle = value as? NSMutableParagraphStyle else { return }

            paragraphAttributes.append((range: range, style: paragraphStyle))
        }

        paragraphAttributes.forEach { attribute in
            attribute.style.lineHeightMultiple = lineHeightMultiplier
            attributedText.addAttribute(.paragraphStyle, value: attribute.style, range: attribute.range)
        }
    }

    public func update(linkTextColor: UIColor, in attributedText: NSMutableAttributedString) {
        attributedText.enumerateAttribute(.link, in: attributedText.range) { value, range, _ in
            guard value is URL else { return }

            attributedText.addAttribute(.foregroundColor, value: linkTextColor, range: range)
            attributedText.addAttribute(.underlineColor, value: linkTextColor, range: range)
        }
    }

    public func update(linksUnderlineStyle: NSUnderlineStyle, in attributedText: NSMutableAttributedString) {
        attributedText.enumerateAttribute(.link, in: attributedText.range) { value, range, _ in
            guard value is URL else { return }

            attributedText.addAttribute(.underlineStyle, value: linksUnderlineStyle.rawValue, range: range)
        }
    }

    public func updateTextShadow(
        using shadowColor: UIColor?,
        offset shadowOffset: CGSize,
        in attributedText: NSMutableAttributedString
    ) {
        guard let shadowColor else {
            attributedText.removeAttribute(.shadow, range: attributedText.range)
            return
        }

        var hasShadowAttribute = false
        attributedText.enumerateAttribute(.shadow, in: attributedText.range) { value, range, _ in
            guard let shadow = value as? NSShadow else { return }

            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadowOffset
            hasShadowAttribute = true
        }

        if !hasShadowAttribute {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadowOffset
            attributedText.addFullRangeAttribute(.shadow, value: shadow)
        }
    }
}
