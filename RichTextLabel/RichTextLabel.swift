//
//  RichTextLabel.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 13/07/2023.
//

import UIKit

class RichTextLabel: UILabel {

    // MARK: - Types

    private struct Link {
        let url: URL
        let range: NSRange
    }

    // MARK: - Constants

    private static let defaultUnderlineStyle = NSUnderlineStyle.single

    // MARK: - Public Properties

    var linkTapAction: ((URL) -> Void)?

    // MARK: - Private Properties

    private lazy var layoutManager: NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        return layoutManager
    }()

    private lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer()
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        return textContainer
    }()

    private lazy var textStorage: NSTextStorage = {
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        return textStorage
    }()

    private var textAttributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]

        if let font {
            attributes[.font] = font
        }
        if let textColor {
            attributes[.foregroundColor] = textColor
        }
        if let shadowColor {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadowOffset
            attributes[.shadow] = shadow
        }

        return attributes
    }

    private lazy var linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

    private var links: [Link] = []
    private var isTouchMoved = false

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func textOrigin() -> CGPoint {
        var textRect = layoutManager.usedRect(for: textContainer)
        textRect.size = CGSize(width: ceil(textRect.size.width), height: ceil(textRect.size.height))
        return textRect.height < bounds.height ? CGPoint(x: 0, y: (bounds.height - textRect.height) / 2) : .zero
    }

    private func updateAttributedText(with text: String?) {
        guard let text else {
            attributedText = NSAttributedString()
            return
        }

        let mutableText = NSMutableAttributedString(string: text, attributes: textAttributes)
        let matches = linkDetector?.matches(in: mutableText.string, range: NSRange(location: 0, length: mutableText.string.count))
        matches?.forEach { match in
            guard let url = match.url else { return }

            links.append(Link(url: url, range: match.range))
            mutableText.addAttribute(.link, value: url, range: match.range)
            mutableText.addAttribute(.underlineStyle, value: Self.defaultUnderlineStyle.rawValue, range: match.range)
        }

        attributedText = mutableText
    }
}

// MARK: - UIVIew

extension RichTextLabel {
    override var frame: CGRect {
        didSet { textContainer.size = bounds.size }
    }

    override var bounds: CGRect {
        didSet { textContainer.size = bounds.size }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
}

// MARK: - UILabel

extension RichTextLabel {
    override var font: UIFont? {
        didSet {
            guard oldValue != font else { return }
            updateAttributedText(with: text)
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        didSet {
            guard oldValue != lineBreakMode else { return }
            textContainer.lineBreakMode = lineBreakMode
            setNeedsDisplay()
        }
    }

    override var numberOfLines: Int {
        didSet {
            guard oldValue != numberOfLines else { return }
            textContainer.maximumNumberOfLines = numberOfLines
            setNeedsDisplay()
        }
    }

    override var shadowColor: UIColor? {
        didSet {
            guard oldValue != shadowColor else { return }
            updateAttributedText(with: text)
        }
    }

    override var shadowOffset: CGSize {
        didSet {
            guard oldValue != shadowOffset else { return }
            updateAttributedText(with: text)
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            guard oldValue != textAlignment else { return }
            updateAttributedText(with: text)
        }
    }

    override var textColor: UIColor? {
        didSet {
            guard oldValue != textColor else { return }
            updateAttributedText(with: text)
        }
    }

    override var text: String? {
        didSet { updateAttributedText(with: text) }
    }

    override var attributedText: NSAttributedString? {
        didSet {
            textStorage.setAttributedString(attributedText ?? NSAttributedString())
            invalidateIntrinsicContentSize()
        }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let oldSize = textContainer.size
        let oldNumberOfLine = numberOfLines

        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = numberOfLines

        let usedRect = layoutManager.usedRect(for: textContainer)
        let size = CGSize(width: ceil(usedRect.width), height: ceil(usedRect.height))
        var textBounds = CGRect(origin: bounds.origin, size: size)
        if textBounds.height < bounds.height {
            textBounds.origin.y += (bounds.height - textBounds.height) / 2
        }

        textContainer.size = oldSize
        textContainer.maximumNumberOfLines = oldNumberOfLine

        return textBounds
    }

    override func drawText(in rect: CGRect) {
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let textOrigin = textOrigin()

        layoutManager.drawBackground(forGlyphRange: glyphRange, at: textOrigin)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textOrigin)
    }
}

// MARK: - UIResponder

extension RichTextLabel {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouchMoved = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        isTouchMoved = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard !isTouchMoved,
              let touchLocation = touches.randomElement()?.location(in: self),
              let touchedLink = link(at: touchLocation)
        else { return }

        linkTapAction?(touchedLink.url)
    }

    private func link(at location: CGPoint) -> Link? {
        guard textStorage.length > 0 else { return nil }

        let textOrigin = textOrigin()
        let correctLocation = CGPoint(x: location.x - textOrigin.x, y: location.y - textOrigin.y)
        let touchedGlyphIndex = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
        let lineUsedRect = layoutManager.lineFragmentUsedRect(forGlyphAt: touchedGlyphIndex, effectiveRange: nil)

        return lineUsedRect.contains(location) ? links.first(where: { $0.range.contains(touchedGlyphIndex) }) : nil
    }
}
