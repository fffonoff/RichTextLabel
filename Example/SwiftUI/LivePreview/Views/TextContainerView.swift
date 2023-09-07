//
//  TextContainerView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import SwiftUI

struct TextContainerView<Content: View>: View {

    @ViewBuilder var content: Content

    private let backgroundColor = UIColor.tertiarySystemBackground.color
    private let shadowColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? .clear : .gray }).color.opacity(0.3)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(backgroundColor)
                .shadow(color: shadowColor, radius: 6, x: 4, y: 4)
                .ignoresSafeArea(edges: .vertical)
            ScrollView(showsIndicators: false) {
                content
            }
            .scrollBounceBasedOnSize()
            GeometryReader { geometry in
                backgroundColor
                    .frame(height: geometry.safeAreaInsets.top)
                    .ignoresSafeArea(edges: .top)
            }
        }
    }
}
