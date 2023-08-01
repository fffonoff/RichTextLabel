//
//  PasteBoardView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 31/07/2023.
//

import SwiftUI

struct PasteBoardView: View {

    @EnvironmentObject var viewModel: LivePreviewViewModel

    var body: some View {
        HStack {
            PasteBoardButton(title: "Paste your text") {
                viewModel.pasteUserText()
            }
            .transition(.scale)

            if viewModel.isUserText {
                PasteBoardButton(title: "Revert") {
                    viewModel.dropUserText()
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(height: 40)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isUserText)
    }
}

struct PasteBoardButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.blue, alignment: .center)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        .transaction { $0.disablesAnimations = true }
    }
}
