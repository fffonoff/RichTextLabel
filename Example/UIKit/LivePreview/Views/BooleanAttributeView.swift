//
//  BooleanAttributeView.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 21/07/2023.
//

import UIKit

final class BooleanAttributeView: UIStackView {

    var valueChanged: ((Bool) -> Void)?

    @Observable private var value: Bool

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17)
        return titleLabel
    }()

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .systemBlue
        switcher.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return switcher
    }()

    init(title: String, value: Observable<Bool>) {
        _value = value
        super.init(frame: .zero)

        titleLabel.text = title
        addArrangedSubview(titleLabel)

        switcher.isOn = value.wrappedValue
        addArrangedSubview(switcher)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged(_ sender: UISwitch) {
        value = sender.isOn
    }
}

extension BooleanAttributeView {
    convenience init(_ description: BooleanAttributeDescription, value: Observable<Bool>) {
        self.init(title: description.title, value: value)
    }
}
