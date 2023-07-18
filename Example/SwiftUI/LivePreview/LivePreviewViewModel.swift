//
//  LivePreviewViewModel.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import SwiftUI

final class LivePreviewViewModel {

    let text = """
    RichTextLabel supports all UILabel functionality as well as custom link handling: https://github.com/fffonoff/RichTextLabel
    """

    let lineNumber = 0
    let fontSize = 21.0
    let textColor: UIColor? = .label
    let textAlignment = NSTextAlignment.natural
}
