//
//  LivePreviewView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import RichTextLabel
import SwiftUI

struct LivePreviewView: View {

    private let viewModel = LivePreviewViewModel()

    @Environment(\.openURL) private var openURL

    private let inset = 24.0

    var body: some View {
        VStack(spacing: 0) {
            TextContainerView {
                RichText(
                    viewModel.text,
                    configure: { richText in
                        richText.font = .systemFont(ofSize: viewModel.fontSize)
                        richText.textColor = viewModel.textColor
                        richText.textAlignment = viewModel.textAlignment
                    },
                    linkTapAction: { url in
                        openURL(url)
                    }
                )
                .lineLimit(viewModel.lineNumber)
                .padding(EdgeInsets(top: inset / 2, leading: inset, bottom: inset, trailing: inset))
            }
            .frame(maxHeight: .infinity)

            Color.clear
                .frame(maxHeight: .infinity)
        }
    }
}

struct LivePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewView()
    }
}