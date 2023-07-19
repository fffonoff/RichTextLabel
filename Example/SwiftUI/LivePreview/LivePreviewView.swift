//
//  LivePreviewView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import RichTextLabel
import SwiftUI

struct LivePreviewView: View {

    @StateObject private var viewModel = LivePreviewViewModel()

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
                .lineLimit(Int(viewModel.lineNumber))
                .padding(EdgeInsets(top: inset / 2, leading: inset, bottom: inset, trailing: inset))
            }
            .frame(maxHeight: .infinity)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    textAttributes
                }
                .font(.system(size: 17))
                .padding(.vertical, 16)
                .padding(.horizontal, inset)
            }
            .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder private var textAttributes: some View {
        NumericAttributeView(viewModel.attributes.lineLimit, value: $viewModel.lineNumber)
        NumericAttributeView(viewModel.attributes.fontSize, value: $viewModel.fontSize)
        MultiOptionAttributeView(viewModel.attributes.textAlignment, selection: $viewModel.textAlignment)
    }
}

struct LivePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewView()
    }
}
