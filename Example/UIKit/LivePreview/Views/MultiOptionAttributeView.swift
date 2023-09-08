//
//  MultiOptionAttributeView.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 19/07/2023.
//

import UIKit

struct AttributeOption<Value: Equatable> {
    let title: String
    let value: Value
}

final class MultiOptionAttributeView<Value: Equatable>: UIStackView {

    var optionSelected: ((Value) -> Void)?

    private let title: String
    private let options: [AttributeOption<Value>]
    @Observable private var value: Value

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.text = "\(title):"
        return titleLabel
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.labelCompat, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    init(title: String, options: [AttributeOption<Value>], value: Observable<Value>) {
        self.title = title
        self.options = options
        _value = value
        super.init(frame: .zero)

        setupLayout()

        value.sink { [weak self] value in
            guard let self else { return }

            if let temp = options.first(where: { $0.value == value }) {
                self.update(with: temp)
            } else {
                self.button.setTitle("None", for: .normal)
            }
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addArrangedSubview(titleLabel)
        let flexibleSpacer = UIView()
        addArrangedSubview(flexibleSpacer)
        addArrangedSubview(button)
    }

    @objc private func buttonTapped() {
        let actionSheetController = UIAlertController(
            title: "Select \(title.lowercased())",
            message: nil,
            preferredStyle: .actionSheet
        )
        for option in options {
            let action = UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.value = option.value
            }
            action.isChecked = option.value == value
            action.titleTextColor = (option.value as? UIColor)?.withAlphaComponent(1)
            actionSheetController.addAction(action)
        }
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        window?.rootViewController?.present(actionSheetController, animated: true)
    }

    private func update(with option: AttributeOption<Value>) {
        let colorValue = option.value as? UIColor
        button.setTitleColor(colorValue?.withAlphaComponent(1) ?? .labelCompat, for: .normal)
        UIView.performWithoutAnimation {
            button.setTitle(option.title, for: .normal)
            button.layoutIfNeeded()
        }
    }
}

extension MultiOptionAttributeView {
    convenience init(_ description: MultiOptionAttributeDescription<Value>, value: Observable<Value>) {
        self.init(title: description.title, options: description.options, value: value)
    }
}
