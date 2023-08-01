//
//  LivePreviewViewModel.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import SwiftUI

final class LivePreviewViewModel: ObservableObject {

    private enum Constants {
        static let defaultText = """
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
    }

    let attributes = AttributesDescriptionProvider()

    @Published var text = Constants.defaultText
    @Published private(set) var isUserText = false

    @Published var lineNumber: Double
    @Published var fontSize: Double
    @Published var textColor: UIColor?
    @Published var textAlignment: NSTextAlignment
    @Published var lineHeightMultiplier: Double
    @Published var textProcessorType: TextProcessorType

    @Published var linkTextColor: UIColor?
    @Published var linkHighlightColor: UIColor?
    @Published var linkHighlightCornerRadius: Double
    @Published private(set) var linkUnderlineStyle: NSUnderlineStyle = []
    @Published var linkUnderlineType: NSUnderlineStyle
    @Published var linkUnderlinePattern: NSUnderlineStyle
    @Published var isPersistentLinkUnderline: Bool
    @Published var underlineByWord: Bool

    @Published var linkLongPressDuration: Double

    @Published var shadowColor: UIColor?
    @Published var shadowXOffset: Double
    @Published var shadowYOffset: Double

    var selectedLinkUrl: URL? {
        didSet {
            if selectedLinkUrl != nil {
                isLinkActionSheetPresented = true
            }
        }
    }
    @Published var isLinkActionSheetPresented = false

    private let pasteBoardHelper: PasteBoardHelper

    init(pasteBoardHelper: PasteBoardHelper) {
        self.pasteBoardHelper = pasteBoardHelper

        lineNumber = attributes.lineLimit.defaultValue
        fontSize = attributes.fontSize.defaultValue
        textColor = attributes.textColor.defaultValue
        textAlignment = attributes.textAlignment.defaultValue
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

        $linkUnderlineType.combineLatest($linkUnderlinePattern, $underlineByWord) {
            (type, pattern, underlineByWord) in

            var linkUnderlineStyle = type.union(pattern)
            if underlineByWord {
                linkUnderlineStyle.insert(.byWord)
            }
            return linkUnderlineStyle
        }
        .assign(to: &$linkUnderlineStyle)

        $isUserText
            .dropFirst()
            .compactMap { [pasteBoardHelper] isUserText in
                isUserText ? pasteBoardHelper.string : Constants.defaultText
            }
            .removeDuplicates()
            .assign(to: &$text)
    }

    func copyToPasteboard(text: String?) {
        guard let text, !text.isEmpty else {
            return
        }

        pasteBoardHelper.string = text
    }

    func pasteUserText() {
        guard pasteBoardHelper.hasStrings, text != pasteBoardHelper.string else {
            return
        }

        isUserText = true
    }

    func dropUserText() {
        isUserText = false
    }
}
