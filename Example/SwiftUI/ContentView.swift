//
//  ContentView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 17/07/2023.
//

import RichTextLabel
import SwiftUI

struct ContentView: View {

    @Environment(\.openURL) private var openURL

    private let text = """
    RichTextLabel supports all UILabel functionality as well as custom link handling: https://github.com/fffonoff/RichTextLabel
    """

    var body: some View {
        ScrollView() {
            RichText(
                text,
                configure: { richText in
                    richText.font = .systemFont(ofSize: 21)
                    richText.textColor = .label
                    richText.textAlignment = .natural // just an example of use, the default value is already .natural
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
