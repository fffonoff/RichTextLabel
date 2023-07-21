//
//  RichTextLabelLayoutManager.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 20/07/2023.
//

import UIKit

final class RichTextLabelLayoutManager: NSLayoutManager {

    var isPersistentLinkUnderline = true

    var selectedLinkRange = NSRange()

    private var usedRectsByRange: [NSRange: [CGRect]] = [:]

    func usedRectsForGlyphs(in range: NSRange) -> [CGRect] {
        if let cachedRects = usedRectsByRange[range] {
            return cachedRects
        }

        var usedRects: [CGRect] = []
        let lineHeight = (textStorage?.attribute(.font, at: range.location) as? UIFont)?.lineHeight
        enumerateLineFragments(forGlyphRange: range) { [weak self] _, lineUsedRect, textContainer, glyphRange, _ in
            guard let self else {
                return
            }

            let usedRange = glyphRange.intersection(range) ?? glyphRange
            var boundingRect = self.boundingRect(forGlyphRange: usedRange, in: textContainer)
            if let lineHeight, boundingRect.height > lineHeight {
                boundingRect.size.height = lineHeight
                boundingRect = boundingRect.offsetBy(dx: 0, dy: lineUsedRect.height - lineHeight)
            }
            usedRects.append(boundingRect.integral)
        }
        usedRectsByRange[range] = usedRects

        return usedRects
    }
}

// MARK: - NSLayoutManager

extension RichTextLabelLayoutManager {

    override func textContainerChangedGeometry(_ container: NSTextContainer) {
        super.textContainerChangedGeometry(container)
        usedRectsByRange.removeAll()
    }

    override func drawUnderline(
        forGlyphRange glyphRange: NSRange,
        underlineType underlineVal: NSUnderlineStyle,
        baselineOffset: CGFloat,
        lineFragmentRect lineRect: CGRect,
        lineFragmentGlyphRange lineGlyphRange: NSRange,
        containerOrigin: CGPoint
    ) {
        var underlineStyle = underlineVal

        let isLinkUnderline = textStorage?.attribute(.link, at: glyphRange.location) != nil
        if isLinkUnderline,
           let attributeValue = textStorage?.attribute(.underlineStyle, at: glyphRange.location) as? Int {
            /// NSLayoutManager always use `NSUnderlineStyle.single` option for links, even if there is no `.underlineStyle` attribute
            /// or if `NSUnderlineStyle.single` option was explicitly removed.
            /// to get around this, we replace passed underline style with the one from NSAttributedString attributes
            underlineStyle = NSUnderlineStyle(rawValue: attributeValue)
            guard isPersistentLinkUnderline || selectedLinkRange.intersection(glyphRange)?.length ?? 0 > 0 else {
                return
            }
        }

        super.drawUnderline(
            forGlyphRange: glyphRange,
            underlineType: underlineStyle,
            baselineOffset: baselineOffset,
            lineFragmentRect: lineRect,
            lineFragmentGlyphRange: lineGlyphRange,
            containerOrigin: containerOrigin
        )
    }

    @available(iOS 13.0, *)
    override func showCGGlyphs(
        _ glyphs: UnsafePointer<CGGlyph>,
        positions: UnsafePointer<CGPoint>,
        count glyphCount: Int,
        font: UIFont,
        textMatrix: CGAffineTransform,
        attributes: [NSAttributedString.Key : Any] = [:],
        in CGContext: CGContext
    ) {
        forceUsingForegroundColor(from: attributes, in: CGContext)
        super.showCGGlyphs(
            glyphs,
            positions: positions,
            count: glyphCount,
            font: font,
            textMatrix: textMatrix,
            attributes: attributes,
            in: CGContext
        )
    }

    override func showCGGlyphs(
        _ glyphs: UnsafePointer<CGGlyph>,
        positions: UnsafePointer<CGPoint>,
        count glyphCount: Int,
        font: UIFont,
        matrix textMatrix: CGAffineTransform,
        attributes: [NSAttributedString.Key : Any] = [:],
        in graphicsContext: CGContext
    ) {
        forceUsingForegroundColor(from: attributes, in: graphicsContext)
        super.showCGGlyphs(
            glyphs,
            positions: positions,
            count: glyphCount,
            font: font,
            matrix: textMatrix,
            attributes: attributes,
            in: graphicsContext
        )
    }

    /// NSLayoutManager has a hard coded internal color for hyperlinks which ignores NSAttributedString.Key.foregroundColor.
    /// To get around this, we force the fill color in the current context to match NSAttributedString.Key.foregroundColor
    private func forceUsingForegroundColor(from attributes: [NSAttributedString.Key : Any], in context: CGContext) {
        guard let foregroundColor = attributes[.foregroundColor] as? UIColor else { return }
        context.setFillColor(foregroundColor.cgColor)
    }
}
