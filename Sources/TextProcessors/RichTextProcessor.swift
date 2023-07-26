//
//  RichTextProcessor.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 25/07/2023.
//

import UIKit

public protocol RichTextProcessor {

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
