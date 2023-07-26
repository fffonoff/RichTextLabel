//
//  ExampleView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import RichTextLabel
import SwiftUI

struct ExampleView: View {

    @Environment(\.openURL) private var openURL

    private let text = """
    RichTextLabel supports all UILabel functionality as well as custom link handling: https://github.com/fffonoff/RichTextLabel
    """

    var body: some View {
        ScrollView() {
            RichText(
                text,
                textProcessor: PlainTextProcessor(),
                configure: { richText in
                    richText.font = .systemFont(ofSize: 21)
                    richText.textColor = .label
                    richText.textAlignment = .natural // just an example of use, the default value is already .natural
                    richText.lineHeightMultiplier = 1.15
                    richText.linkTextColor = .link
                    richText.linkHighlightColor = #colorLiteral(red: 0.68, green: 0.85, blue: 0.9, alpha: 0.35)
                    richText.linkHighlightCornerRadius = 6
                    richText.linkUnderlineStyle = .single
                    richText.isPersistentLinkUnderline = false
                },
                linkTapAction: { url in
                    openURL(url)
                }
            )
            .lineLimit(0)
            .padding(20)
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
