//
//  RichTextProcessor.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 25/07/2023.
//

import UIKit

public protocol RichTextProcessor {

    /// If true, ``RichTextLabel`` will asynchronously call text processor's ``attributedText(from:withTextColor:)`` on the main DispatchQueue.
    /// Useful when the ``RichTextProcessor`` relies on system HTML Importer, which is extremely unstable and doesn't work well with SwiftUI.
    ///
    /// Example where this flag set to true: ``TextWithHtmlProcessor``
    var requiresAsyncTextProcessing: Bool { get }

    func attributedText(from text: String, withTextColor textColor: UIColor) -> NSAttributedString?

    func update(font: UIFont, in attributedText: NSMutableAttributedString)
    func update(textColor: UIColor, oldValue: UIColor?, in attributedText: NSMutableAttributedString)
    func update(textAlignment: NSTextAlignment, in attributedText: NSMutableAttributedString)
    func update(lineBreakStrategy: NSParagraphStyle.LineBreakStrategy, in attributedText: NSMutableAttributedString)
    func update(lineHeightMultiplier: CGFloat, in attributedText: NSMutableAttributedString)
    func update(linkTextColor color: UIColor, in attributedText: NSMutableAttributedString)
    func update(linksUnderlineStyle style: NSUnderlineStyle, in attributedText: NSMutableAttributedString)
    func updateTextShadow(
        using shadowColor: UIColor?,
        offset shadowOffset: CGSize,
        in attributedText: NSMutableAttributedString
    )
}

// MARK: - RichTextProcessor+Default

public extension RichTextProcessor {

    var requiresAsyncTextProcessing: Bool { false }

    func update(font: UIFont, in attributedText: NSMutableAttributedString) {
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

    func update(textColor: UIColor, oldValue: UIColor?, in attributedText: NSMutableAttributedString) {
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

    func update(textAlignment: NSTextAlignment, in attributedText: NSMutableAttributedString) {
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

    func update(lineBreakStrategy: NSParagraphStyle.LineBreakStrategy, in attributedText: NSMutableAttributedString) {
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

    func update(lineHeightMultiplier: CGFloat, in attributedText: NSMutableAttributedString) {
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

    func update(linkTextColor: UIColor, in attributedText: NSMutableAttributedString) {
        attributedText.enumerateAttribute(.link, in: attributedText.range) { value, range, _ in
            guard value is URL else { return }

            attributedText.addAttribute(.foregroundColor, value: linkTextColor, range: range)
            attributedText.addAttribute(.underlineColor, value: linkTextColor, range: range)
        }
    }

    func update(linksUnderlineStyle: NSUnderlineStyle, in attributedText: NSMutableAttributedString) {
        attributedText.enumerateAttribute(.link, in: attributedText.range) { value, range, _ in
            guard value is URL else { return }

            attributedText.addAttribute(.underlineStyle, value: linksUnderlineStyle.rawValue, range: range)
        }
    }

    func updateTextShadow(
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
