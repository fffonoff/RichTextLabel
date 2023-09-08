//
//  LivePreviewViewModel.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 18/07/2023.
//

import UIKit

final class LivePreviewViewModel {

    let attributes = AttributesDescriptionProvider()

    private(set) var text = """
    <b style=\"color: orange;\">RichTextLabel</b> is a convinient replacement for standard UILabel \
    supporting URL links handling customization and ability to work with html-text using custom parsers, \
    which support all the standard html formatting tags: <br>\
    <ul>\
    <li><del>Strikethrough</del></li>\
    <li><b>Bold</b></li>\
    <li><i>Italic</i></li>\
    </ul>\
    In addition to that you can use your own custom written parser\
    <br>\
    <br>\
    <a href=\"https://github.com/fffonoff/RichTextLabel\">Github link</a>
    """

    @Observable private(set) var fontSize: Double
    @Observable private(set) var textColor: UIColor?
    @Observable private(set) var numberOfLines: Double
    @Observable private(set) var textAlignment: NSTextAlignment
    @Observable private(set) var lineBreakMode: NSLineBreakMode
    @Observable private(set) var lineHeightMultiplier: Double
    @Observable private(set) var textProcessorType: TextProcessorType

    @Observable private(set) var linkTextColor: UIColor?
    @Observable private(set) var linkHighlightColor: UIColor?
    @Observable private(set) var linkHighlightCornerRadius: Double
    @Observable private(set) var linkUnderlineStyle: NSUnderlineStyle = []
    @Observable private(set) var linkUnderlineType: NSUnderlineStyle
    @Observable private(set) var linkUnderlinePattern: NSUnderlineStyle
    @Observable private(set) var isPersistentLinkUnderline: Bool
    @Observable private(set) var underlineByWord: Bool

    @Observable private(set) var linkLongPressDuration: Double

    @Observable private(set) var shadowColor: UIColor?
    @Observable private(set) var shadowXOffset: Double
    @Observable private(set) var shadowYOffset: Double

    init() {
        numberOfLines = attributes.lineLimit.defaultValue
        fontSize = attributes.fontSize.defaultValue
        textColor = attributes.textColor.defaultValue
        textAlignment = attributes.textAlignment.defaultValue
        lineBreakMode = attributes.lineBreakMode.defaultValue
        lineHeightMultiplier = attributes.lineHeightMultiplier.defaultValue
        textProcessorType = attributes.textProcessor.defaultValue

        linkTextColor = attributes.linkTextColor.defaultValue
        linkHighlightColor = attributes.linkHighlightColor.defaultValue
        linkHighlightCornerRadius = attributes.linkHighlightCornerRadius.defaultValue
        linkUnderlineType = attributes.linkUnderlineType.defaultValue
        linkUnderlinePattern = attributes.linkUnderlinePattern.defaultValue
        isPersistentLinkUnderline = attributes.persistentUnderline.defaultValue
        underlineByWord = attributes.underlineByWord.defaultValue

        linkLongPressDuration = attributes.linkLongPressDuration.defaultValue

        shadowColor = attributes.shadowColor.defaultValue
        shadowXOffset = attributes.shadowXOffset.defaultValue
        shadowYOffset = attributes.shadowYOffset.defaultValue

        _linkUnderlineStyle = $linkUnderlineType.combineLatest($linkUnderlinePattern, $underlineByWord) {
            (type, pattern, underlineByWord) in

            var linkUnderlineStyle = type.union(pattern)
            if underlineByWord {
                linkUnderlineStyle.insert(.byWord)
            }

            return linkUnderlineStyle
        }
    }
}
