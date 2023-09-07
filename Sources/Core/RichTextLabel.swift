//
//  RichTextLabel.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 13/07/2023.
//

import UIKit

public class RichTextLabel: UILabel {

    // MARK: - Public Properties

    public var textProcessor: RichTextProcessor {
        didSet {
            guard type(of: oldValue) != type(of: textProcessor) else { return }
            processText()
        }
    }

    public var linkTapAction: ((URL) -> Void)?

    public var linkLongPressAction: ((URL) -> Void)? {
        didSet {
            linksHandler.isLongPressTrackingEnabled = linkLongPressAction != nil
        }
    }

    public var linkLongPressDuration: TimeInterval {
        get { linksHandler.linkLongPressDuration }
        set { linksHandler.linkLongPressDuration = newValue }
    }

    public var lineHeightMultiplier: CGFloat = 1 {
        didSet {
            guard oldValue != lineHeightMultiplier else { return }
            textProcessor.update(lineHeightMultiplier: lineHeightMultiplier, in: textStorage)
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    public var linkTextColor: UIColor? = .linkCompat {
        didSet {
            guard oldValue != linkTextColor else { return }
            textProcessor.update(linkTextColor: linkTextColor ?? textColor ?? super.textColor, in: textStorage)
            setNeedsDisplay()
        }
    }

    public var linkHighlightColor: UIColor? = #colorLiteral(red: 0.68, green: 0.85, blue: 0.9, alpha: 0.35) {
        didSet {
            guard oldValue != linkHighlightColor else { return }
            linksHighlightLayer.fillColor = linkHighlightColor?.cgColor
        }
    }

    public var linkHighlightCornerRadius: CGFloat = 6

    public var linkUnderlineStyle: NSUnderlineStyle = .single {
        didSet {
            guard oldValue != linkUnderlineStyle else { return }
            textProcessor.update(linksUnderlineStyle: linkUnderlineStyle, in: textStorage)
            setNeedsDisplay()
        }
    }

    public var isPersistentLinkUnderline: Bool {
        get { layoutManager.isPersistentLinkUnderline }
        set {
            guard newValue != isPersistentLinkUnderline else { return }
            layoutManager.isPersistentLinkUnderline = newValue
            setNeedsDisplay()
        }
    }

    private(set) lazy var layoutManager: RichTextLabelLayoutManager = {
        let layoutManager = RichTextLabelLayoutManager()
        layoutManager.addTextContainer(textContainer)
        return layoutManager
    }()

    private(set) lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer()
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        return textContainer
    }()

    var textContainerOrigin: CGPoint {
        let textHeight = ceil(layoutManager.usedRect(for: textContainer).height)
        let yOrigin = textHeight < bounds.height ? (bounds.height - textHeight) / 2 : 0

        return CGPoint(x: textContainer.lineFragmentPadding, y: yOrigin)
    }

    // MARK: - Private Properties

    private lazy var textStorage: NSTextStorage = {
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        return textStorage
    }()

    private lazy var linksHandler = LinksInteractionHandler()

    private lazy var linksHighlightLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.bounds = bounds
        layer.fillColor = linkHighlightColor?.cgColor
        layer.opacity = 0
        return layer
    }()

    private var selectedLinkRange = NSRange() {
        didSet {
            guard oldValue != selectedLinkRange else { return }

            layoutManager.selectedLinkRange = selectedLinkRange
            highlightLink(in: selectedLinkRange)
            setNeedsDisplay()
        }
    }

    private let linkHighlightFadeInDuration: TimeInterval = 0.2
    private let linkHighlightFadeOutDuration: TimeInterval = 0.3

    // MARK: - Init

    public init(textProcessor: RichTextProcessor = PlainTextProcessor()) {
        self.textProcessor = textProcessor
        super.init(frame: .zero)

        setupLinksHandling()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    public func batchConfigure(_ configure: (RichTextLabel) -> Void) {
        textStorage.removeLayoutManager(layoutManager)
        textStorage.beginEditing()
        configure(self)
        textStorage.endEditing()
        textStorage.addLayoutManager(layoutManager)
    }

    // MARK: - Private Methods

    private func setupLinksHandling() {
        isUserInteractionEnabled = true

        linksHandler.attach(to: self) { [weak self] state in
            switch state {
            case .idle:
                self?.selectedLinkRange = NSRange()
            case .linkTouched(let link):
                self?.selectedLinkRange = link.range
            case .linkTapped(let link):
                self?.linkTapAction?(link.url)
                self?.selectedLinkRange = NSRange()
            case .linkLongPressed(let link):
                self?.linkLongPressAction?(link.url)
                self?.selectedLinkRange = NSRange()
            }
        }
    }

    private func highlightLink(in linkRange: NSRange) {
        guard linkHighlightColor != nil else { return }

        let isVisible = linkRange.length > 0
        if isVisible {
            let path = UIBezierPath()
            for rect in layoutManager.usedRectsForGlyphs(in: linkRange) {
                let insetRect = rect.insetBy(dx: -linkHighlightCornerRadius, dy: -2)
                path.append(UIBezierPath(roundedRect: insetRect, cornerRadius: linkHighlightCornerRadius))
            }

            linksHighlightLayer.path = path.cgPath
        }

        CATransaction.begin()
        let duration = isVisible ? linkHighlightFadeInDuration : linkHighlightFadeOutDuration
        CATransaction.setAnimationDuration(duration)
        linksHighlightLayer.opacity = isVisible ? 1 : 0
        CATransaction.commit()
    }
}

// MARK: - UIVIew

public extension RichTextLabel {
    override var frame: CGRect {
        didSet { textContainer.size = bounds.size }
    }

    override var bounds: CGRect {
        didSet { textContainer.size = bounds.size }
    }

    override func didMoveToSuperview() {
        linksHighlightLayer.removeFromSuperlayer()
        if let superview {
            /// we utilize superview's layer to draw links highlight under a text
            superview.layer.insertSublayer(linksHighlightLayer, below: layer)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textContainer.size = bounds.size
        linksHighlightLayer.frame = frame

        linksHandler.textLabelDidLayout()
    }
}

// MARK: - UILabel

public extension RichTextLabel {

    @available(*, unavailable, message: "this feature is not supported yet")
    override var adjustsFontSizeToFitWidth: Bool {
        get { false }
        set { }
    }

    override var font: UIFont? {
        didSet {
            guard oldValue != font else { return }
            textProcessor.update(font: font ?? super.font, in: textStorage)
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    override var lineBreakMode: NSLineBreakMode {
        didSet {
            guard oldValue != lineBreakMode else { return }
            textContainer.lineBreakMode = lineBreakMode
            setNeedsDisplay()
        }
    }

    override var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy {
        get {
            if #available(iOS 14, *) {
                return super.lineBreakStrategy
            }
            return []
        }
        set {
            guard #available(iOS 14, *), newValue != lineBreakStrategy else { return }
            super.lineBreakStrategy = lineBreakStrategy
            textProcessor.update(lineBreakStrategy: lineBreakStrategy, in: textStorage)
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
            textProcessor.updateTextShadow(using: shadowColor, offset: shadowOffset, in: textStorage)
            setNeedsDisplay()
        }
    }

    override var shadowOffset: CGSize {
        didSet {
            guard oldValue != shadowOffset else { return }
            textProcessor.updateTextShadow(using: shadowColor, offset: shadowOffset, in: textStorage)
            setNeedsDisplay()
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            guard oldValue != textAlignment else { return }
            textProcessor.update(textAlignment: textAlignment, in: textStorage)
            setNeedsDisplay()
        }
    }

    override var textColor: UIColor? {
        didSet {
            guard oldValue != textColor else { return }
            textProcessor.update(textColor: textColor ?? super.textColor, oldValue: oldValue, in: textStorage)
            setNeedsDisplay()
        }
    }

    override var text: String? {
        didSet {
            guard oldValue != text else { return }
            processText()
        }
    }

    override var attributedText: NSAttributedString? {
        get { textStorage }
        set {
            linksHandler.updateLinks(for: newValue)
            textStorage.setAttributedString(decorateAttributedText(newValue) ?? NSAttributedString())
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
        let textOrigin = textContainerOrigin

        layoutManager.drawBackground(forGlyphRange: glyphRange, at: textOrigin)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textOrigin)
    }

    private func processText() {
        guard let text, !text.isEmpty else {
            attributedText = nil
            return
        }

        if textProcessor.requiresAsyncTextProcessing {
            DispatchQueue.main.async { [weak self] in
                self?.updateAttributedText(using: text)
            }
        } else {
            updateAttributedText(using: text)
        }
    }

    private func updateAttributedText(using text: String) {
        attributedText = textProcessor.attributedText(from: text, withTextColor: textColor ?? super.textColor)
        setNeedsDisplay()
    }

    private func decorateAttributedText(_ attributedText: NSAttributedString?) -> NSAttributedString? {
        guard let attributedText else {
            return nil
        }

        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        textProcessor.update(font: font ?? super.font, in: mutableAttributedText)
        textProcessor.update(textColor: textColor ?? super.textColor, oldValue: nil, in: mutableAttributedText)
        textProcessor.update(textAlignment: textAlignment, in: mutableAttributedText)
        if #available(iOS 14, *) {
            textProcessor.update(lineBreakStrategy: lineBreakStrategy, in: mutableAttributedText)
        }
        textProcessor.update(lineHeightMultiplier: lineHeightMultiplier, in: mutableAttributedText)
        textProcessor.update(linkTextColor: linkTextColor ?? textColor ?? super.textColor, in: mutableAttributedText)
        textProcessor.update(linksUnderlineStyle: linkUnderlineStyle, in: mutableAttributedText)
        textProcessor.updateTextShadow(using: shadowColor, offset: shadowOffset, in: mutableAttributedText)

        return mutableAttributedText
    }
}

// MARK: - UITraitEnvironment

public extension RichTextLabel {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            linksHighlightLayer.fillColor = linkHighlightColor?.cgColor
        }
    }
}
