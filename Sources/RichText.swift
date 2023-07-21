//
//  RichText.swift
//  RichTextLabel
//
//  Created by Roman Trifonov on 17/07/2023.
//

import SwiftUI

// MARK: - RichText

@available(iOS 14.0, *)
public struct RichText: View {

    private let text: String?
    private let configure: ((_ richText: RichTextLabelProxy) -> Void)?
    private let linkTapAction: ((_ url: URL) -> Void)?

    @State private var height = CGFloat.zero

    public var body: some View {
        if #available(iOS 16, *) {
            richTextLabelRepresentable()
        } else {
            GeometryReader { geometry in
                richTextLabelRepresentable(with: geometry)
            }
            .frame(height: height)
        }
    }

    public init(
        _ text: String? = nil,
        configure: ((RichTextLabelProxy) -> Void)? = nil,
        linkTapAction: ((URL) -> Void)? = nil
    ) {
        self.text = text
        self.configure = configure
        self.linkTapAction = linkTapAction
    }

    private func richTextLabelRepresentable(with geometry: GeometryProxy? = nil) -> some View {
        return RichTextLabelRepresentable(
            text: text,
            configure: configure,
            linkTapAction: linkTapAction,
            geometry: geometry,
            height: $height
        )
    }
}

// MARK: - RichTextLabelRepresentable

@available(iOS 14.0, *)
struct RichTextLabelRepresentable: UIViewRepresentable {

    typealias UIViewType = RichTextLabel

    let text: String?
    let configure: ((RichTextLabelProxy) -> Void)?
    let linkTapAction: ((_ url: URL) -> Void)?

    let geometry: GeometryProxy?
    @Binding var height: CGFloat

    @Environment(\.lineLimit) private var lineLimit

    func makeUIView(context: Context) -> UIViewType {
        let label = RichTextLabel()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        configure?(RichTextLabelProxy(originalView: uiView))
        uiView.numberOfLines = lineLimit ?? 0
        uiView.linkTapAction = linkTapAction

        uiView.text = text

        DispatchQueue.main.async {
            if let geometry {
                height = uiView.sizeThatFits(CGSize(width: geometry.size.width, height: .infinity)).height
            }
        }
    }

    @available(iOS 16.0, *)
    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIViewType,
        context: Context
    ) -> CGSize? {
        let proposalWidth = proposal.width ?? .infinity
        let proposalHeight = proposal.height ?? .infinity
        let sizeThatFits = uiView.sizeThatFits(CGSize(width: proposalWidth, height: proposalHeight))

        return CGSize(width: proposalWidth, height: sizeThatFits.height)
    }
}

// MARK: - RichTextLabelProxy

@available(iOS 14.0, *)
public struct RichTextLabelProxy {

    public var font: UIFont? {
        get { originalView.font }
        nonmutating set { originalView.font = newValue }
    }

    public var textColor: UIColor? {
        get { originalView.textColor }
        nonmutating set { originalView.textColor = newValue }
    }

    public var textAlignment: NSTextAlignment {
        get { originalView.textAlignment }
        nonmutating set { originalView.textAlignment = newValue }
    }

    public var lineBreakMode: NSLineBreakMode {
        get { originalView.lineBreakMode }
        nonmutating set { originalView.lineBreakMode = newValue }
    }

    public var linkTextColor: UIColor? {
        get { originalView.linkTextColor }
        nonmutating set { originalView.linkTextColor = newValue }
    }

    public var linkHighlightColor: UIColor? {
        get { originalView.linkHighlightColor }
        nonmutating set { originalView.linkHighlightColor = newValue }
    }

    public var linkHighlightCornerRadius: Double {
        get { originalView.linkHighlightCornerRadius }
        nonmutating set { originalView.linkHighlightCornerRadius = newValue }
    }

    public var linkUnderlineStyle: NSUnderlineStyle {
        get { originalView.linkUnderlineStyle }
        nonmutating set { originalView.linkUnderlineStyle = newValue }
    }

    public var isPersistentLinkUnderline: Bool {
        get { originalView.isPersistentLinkUnderline }
        nonmutating set { originalView.isPersistentLinkUnderline = newValue }
    }

    public var shadowColor: UIColor? {
        get { originalView.shadowColor }
        nonmutating set { originalView.shadowColor = newValue }
    }

    public var shadowOffset: CGSize {
        get { originalView.shadowOffset }
        nonmutating set { originalView.shadowOffset = newValue }
    }

    private let originalView: RichTextLabel

    init(originalView: RichTextLabel) {
        self.originalView = originalView
    }
}
