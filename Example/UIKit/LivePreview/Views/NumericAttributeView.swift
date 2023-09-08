//
//  NumericAttributeView.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 18/07/2023.
//

import UIKit

final class NumericAttributeView: UIStackView {

    var valueChanged: ((Double) -> Void)?

    private let titleFormat: String

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17)
        return titleLabel
    }()

    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return stepper
    }()

    @Observable var value: Double

    init(titleFormat: String, range: ClosedRange<Double>, step: Double = 1, value: Observable<Double>) {
        self.titleFormat = titleFormat
        _value = value
        super.init(frame: .zero)

        stepper.minimumValue = range.lowerBound
        stepper.maximumValue = range.upperBound
        stepper.stepValue = step
        stepper.value = value.wrappedValue

        setupLayout()
        updateTitle()

        value.sink { [titleLabel] in
            titleLabel.text = String(format: titleFormat, $0)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(stepper)
    }

    @objc private func valueChanged(_ sender: UIStepper) {
        value = sender.value
    }

    private func updateTitle() {
        titleLabel.text = String(format: titleFormat, stepper.value)
    }
}

extension NumericAttributeView {
    convenience init(_ description: NumericAttributeDescription, value: Observable<Double>) {
        self.init(titleFormat: description.titleFormat, range: description.range, step: description.step, value: value)
    }
}
