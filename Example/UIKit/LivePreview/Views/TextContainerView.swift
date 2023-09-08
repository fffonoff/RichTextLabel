//
//  TextContainerView.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 18/07/2023.
//

import UIKit

final class TextContainerView: UIView {

    private let shadowColor: UIColor = {
        let shadowColor: UIColor
        if #available(iOS 13.0, *) {
            shadowColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? .clear : .gray })
        } else {
            shadowColor = .gray
        }

        return shadowColor.withAlphaComponent(0.3)
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .tertiarySystemBackgroundCompat
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        layer.shadowOpacity = 1
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 4, height: 4)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor = shadowColor.cgColor
        }
    }
}
