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
                        richText.lineHeightMultiplier = viewModel.lineHeightMultiplier
                        richText.linkTextColor = viewModel.linkTextColor
                        richText.linkHighlightColor = viewModel.linkHighlightColor
                        richText.linkHighlightCornerRadius = viewModel.linkHighlightCornerRadius
                        richText.linkUnderlineStyle = viewModel.linkUnderlineStyle
                        richText.isPersistentLinkUnderline = viewModel.isPersistentLinkUnderline
                        richText.shadowColor = viewModel.shadowColor
                        richText.shadowOffset = CGSize(
                            width: viewModel.shadowXOffset,
                            height: viewModel.shadowYOffset
                        )
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
                    linksDecorations
                    textShadowAttributes
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
        MultiOptionAttributeView(viewModel.attributes.textColor, selection: $viewModel.textColor)
        MultiOptionAttributeView(viewModel.attributes.textAlignment, selection: $viewModel.textAlignment)
        NumericAttributeView(viewModel.attributes.lineHeightMultiplier, value: $viewModel.lineHeightMultiplier)
    }

    @ViewBuilder private var linksDecorations: some View {
        AttributeGroupTitleView(viewModel.attributes.linksDecorationsGroupTitle)
        MultiOptionAttributeView(viewModel.attributes.linkTextColor, selection: $viewModel.linkTextColor)
        MultiOptionAttributeView(viewModel.attributes.linkHighlightColor, selection: $viewModel.linkHighlightColor)
        NumericAttributeView(
            viewModel.attributes.linkHighlightCornerRadius,
            value: $viewModel.linkHighlightCornerRadius
        )
        MultiOptionAttributeView(viewModel.attributes.linkUnderlineType, selection: $viewModel.linkUnderlineType)
        if !viewModel.linkUnderlineType.isEmpty {
            MultiOptionAttributeView(
                viewModel.attributes.linkUnderlinePattern,
                selection: $viewModel.linkUnderlinePattern
            )
            BooleanAttributeView(viewModel.attributes.persistentUnderline, isOn: $viewModel.isPersistentLinkUnderline)
            BooleanAttributeView(viewModel.attributes.underlineByWord, isOn: $viewModel.underlineByWord)
        }
    }

    @ViewBuilder private var textShadowAttributes: some View {
        AttributeGroupTitleView(viewModel.attributes.textShadowGroupTitle)
        MultiOptionAttributeView(viewModel.attributes.shadowColor, selection: $viewModel.shadowColor)
        if viewModel.shadowColor != nil {
            NumericAttributeView(viewModel.attributes.shadowXOffset, value: $viewModel.shadowXOffset)
            NumericAttributeView(viewModel.attributes.shadowYOffset, value: $viewModel.shadowYOffset)
        }
    }
}

struct LivePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewView()
    }
}
