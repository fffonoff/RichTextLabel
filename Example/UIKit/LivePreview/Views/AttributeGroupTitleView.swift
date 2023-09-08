//
//  AttributesGroupTitle.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 21/07/2023.
//

import UIKit

final class AttributeGroupTitleView: UILabel {

    override var intrinsicContentSize: CGSize { CGSize(width: super.intrinsicContentSize.width, height: 32) }

    init(_ title: String) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 17)
        textColor = .gray
        text = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
