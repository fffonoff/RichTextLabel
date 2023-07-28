//
//  TextProcessorType.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 27/07/2023.
//

import RichTextLabelDT

enum TextProcessorType {
    case plainText
    case textWithHtml
    case textWithHtmlDT
}

extension TextProcessorType {
    func create() -> RichTextProcessor {
        switch self {
        case .plainText:
            return PlainTextProcessor()
        case .textWithHtml:
            return TextWithHtmlProcessor()
        case .textWithHtmlDT:
            return DTTextWithHtmlProcessor()
        }
    }
}
