//
//  LivePreviewViewController.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 18/07/2023.
//

import RichTextLabelDT
import UIKit

final class LivePreviewViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel = LivePreviewViewModel()

    private let inset: CGFloat = 24

    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        return mainStackView
    }()

    // MARK: Text

    private let textContainer = TextContainerView()

    private let textScrollView: UIScrollView = {
        let textScrollView = UIScrollView()
        textScrollView.showsHorizontalScrollIndicator = false
        textScrollView.showsVerticalScrollIndicator = false
        return textScrollView
    }()

    private let textLabel = RichTextLabel(textProcessor: DTTextWithHtmlProcessor())

    // MARK: Attributes

    private let attributesScrollView: UIScrollView = {
        let attributesScrollView = UIScrollView()
        attributesScrollView.showsHorizontalScrollIndicator = false
        attributesScrollView.showsVerticalScrollIndicator = false
        return attributesScrollView
    }()

    private let attributesStackView: UIStackView = {
        let attributesStackView = UIStackView()
        attributesStackView.axis = .vertical
        attributesStackView.spacing = 8
        return attributesStackView
    }()

    private lazy var lineNumberView = NumericAttributeView(
        viewModel.attributes.lineLimit,
        value: viewModel.$numberOfLines
    )
    private lazy var fontSizeView = NumericAttributeView(
        viewModel.attributes.fontSize,
        value: viewModel.$fontSize
    )
    private lazy var textColorView = MultiOptionAttributeView(
        viewModel.attributes.textColor,
        value: viewModel.$textColor
    )
    private lazy var textAlignmentView = MultiOptionAttributeView(
        viewModel.attributes.textAlignment,
        value: viewModel.$textAlignment
    )
    private lazy var lineBreakModeView = MultiOptionAttributeView(
        viewModel.attributes.lineBreakMode,
        value: viewModel.$lineBreakMode
    )
    private lazy var lineHeightMultiplierView = NumericAttributeView(
        viewModel.attributes.lineHeightMultiplier,
        value: viewModel.$lineHeightMultiplier
    )
    private lazy var textProcessorView = MultiOptionAttributeView(
        viewModel.attributes.textProcessor,
        value: viewModel.$textProcessorType
    )

    private lazy var linksDecorationsGroupTitle = AttributeGroupTitleView(
        viewModel.attributes.linksDecorationsGroupTitle
    )
    private lazy var linkTextColorView = MultiOptionAttributeView(
        viewModel.attributes.linkTextColor,
        value: viewModel.$linkTextColor
    )
    private lazy var linkBackgroundColorView = MultiOptionAttributeView(
        viewModel.attributes.linkHighlightColor,
        value: viewModel.$linkHighlightColor
    )
    private lazy var linkHighlightCornerRadiusView = NumericAttributeView(
        viewModel.attributes.linkHighlightCornerRadius,
        value: viewModel.$linkHighlightCornerRadius
    )
    private lazy var linkUnderlineTypeView = MultiOptionAttributeView(
        viewModel.attributes.linkUnderlineType,
        value: viewModel.$linkUnderlineType
    )
    private lazy var linkUnderlinePatternView = MultiOptionAttributeView(
        viewModel.attributes.linkUnderlinePattern,
        value: viewModel.$linkUnderlinePattern
    )
    private lazy var persistentUnderlineView = BooleanAttributeView(
        viewModel.attributes.persistentUnderline,
        value: viewModel.$isPersistentLinkUnderline
    )
    private lazy var underlineByWordView = BooleanAttributeView(
        viewModel.attributes.underlineByWord,
        value: viewModel.$underlineByWord
    )

    private lazy var linksInteractionGroupTitle = AttributeGroupTitleView(
        viewModel.attributes.linksInteractionGroupTitle
    )
    private lazy var linkLongPressDuration = NumericAttributeView(
        viewModel.attributes.linkLongPressDuration,
        value: viewModel.$linkLongPressDuration
    )

    private lazy var textShadowGroupTitle = AttributeGroupTitleView(viewModel.attributes.textShadowGroupTitle)
    private lazy var shadowColorView = MultiOptionAttributeView(
        viewModel.attributes.shadowColor,
        value: viewModel.$shadowColor
    )
    private lazy var shadowXOffsetView = NumericAttributeView(
        viewModel.attributes.shadowXOffset,
        value: viewModel.$shadowXOffset
    )
    private lazy var shadowYOffsetView = NumericAttributeView(
        viewModel.attributes.shadowYOffset,
        value: viewModel.$shadowYOffset
    )
}

// MARK: - UIViewController

extension LivePreviewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackgroundCompat
        if #available(iOS 15.0, *) {
            setContentScrollView(attributesScrollView)
        }
        setupLayout()
        setupTextLabel()
    }

    private func setupLayout() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        mainStackView.addArrangedSubview(textContainer)
        textContainer.addSubview(textScrollView)
        textScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textScrollView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            textScrollView.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor),
            textScrollView.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor)
        ])

        textScrollView.contentInset = UIEdgeInsets(top: inset / 2, left: inset, bottom: inset, right: inset)
        textScrollView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: textScrollView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: textScrollView.leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: textScrollView.bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: textScrollView.trailingAnchor),
            textLabel.widthAnchor.constraint(equalTo: textScrollView.widthAnchor, multiplier: 1, constant: 2 * -inset)
        ])

        mainStackView.addArrangedSubview(attributesScrollView)

        attributesScrollView.contentInset = UIEdgeInsets(top: 16, left: inset, bottom: 16, right: inset)
        attributesScrollView.addSubview(attributesStackView)
        attributesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            attributesStackView.topAnchor.constraint(equalTo: attributesScrollView.topAnchor),
            attributesStackView.leadingAnchor.constraint(equalTo: attributesScrollView.leadingAnchor),
            attributesStackView.bottomAnchor.constraint(equalTo: attributesScrollView.bottomAnchor),
            attributesStackView.trailingAnchor.constraint(equalTo: attributesScrollView.trailingAnchor),
            attributesStackView.widthAnchor.constraint(
                equalTo: attributesScrollView.widthAnchor, multiplier: 1, constant: 2 * -inset
            )
        ])

        attributesStackView.addArrangedSubview(lineNumberView)
        attributesStackView.addArrangedSubview(fontSizeView)
        attributesStackView.addArrangedSubview(textColorView)
        attributesStackView.addArrangedSubview(textAlignmentView)
        attributesStackView.addArrangedSubview(lineBreakModeView)
        attributesStackView.addArrangedSubview(lineHeightMultiplierView)
        attributesStackView.addArrangedSubview(textProcessorView)

        attributesStackView.addArrangedSubview(linksDecorationsGroupTitle)
        attributesStackView.addArrangedSubview(linkTextColorView)
        attributesStackView.addArrangedSubview(linkBackgroundColorView)
        attributesStackView.addArrangedSubview(linkHighlightCornerRadiusView)
        attributesStackView.addArrangedSubview(linkUnderlineTypeView)
        attributesStackView.addArrangedSubview(linkUnderlinePatternView)
        attributesStackView.addArrangedSubview(persistentUnderlineView)
        attributesStackView.addArrangedSubview(underlineByWordView)

        attributesStackView.addArrangedSubview(linksInteractionGroupTitle)
        attributesStackView.addArrangedSubview(linkLongPressDuration)

        attributesStackView.addArrangedSubview(textShadowGroupTitle)
        attributesStackView.addArrangedSubview(shadowColorView)
        attributesStackView.addArrangedSubview(shadowXOffsetView)
        attributesStackView.addArrangedSubview(shadowYOffsetView)
    }

    private func setupTextLabel() {
        textLabel.text = viewModel.text

        viewModel.$numberOfLines.sink { [textLabel, lineBreakModeView] numberOfLines in
            textLabel.numberOfLines = Int(numberOfLines)
            lineBreakModeView.isHidden = numberOfLines == 0
        }
        viewModel.$fontSize.sink { [textLabel] in
            textLabel.font = textLabel.font?.withSize($0)
        }
        viewModel.$textAlignment.assign(to: \.textAlignment, on: textLabel)
        viewModel.$lineBreakMode.assign(to: \.lineBreakMode, on: textLabel)
        viewModel.$textColor.assign(to: \.textColor, on: textLabel)
        viewModel.$lineHeightMultiplier.sink { [textLabel] in
            textLabel.lineHeightMultiplier = $0
        }
        viewModel.$textProcessorType.sink { [textLabel] type in
            textLabel.textProcessor = type.create()
        }

        viewModel.$linkTextColor.assign(to: \.linkTextColor, on: textLabel)
        viewModel.$linkHighlightColor.assign(to: \.linkHighlightColor, on: textLabel)
        viewModel.$linkHighlightCornerRadius.sink { [textLabel] in
            textLabel.linkHighlightCornerRadius = $0
        }
        viewModel.$linkUnderlineStyle.assign(to: \.linkUnderlineStyle, on: textLabel)
        viewModel.$linkUnderlineType.sink { [weak self] linkUnderlineType in
            let isNoUnderlineType = linkUnderlineType.isEmpty
            self?.linkUnderlinePatternView.isHidden = isNoUnderlineType
            self?.persistentUnderlineView.isHidden = isNoUnderlineType
            self?.underlineByWordView.isHidden = isNoUnderlineType
        }
        viewModel.$isPersistentLinkUnderline.assign(to: \.isPersistentLinkUnderline, on: textLabel)

        viewModel.$linkLongPressDuration.assign(to: \.linkLongPressDuration, on: textLabel)

        viewModel.$shadowColor.sink { [weak self] shadowColor in
            self?.textLabel.shadowColor = shadowColor
            let isNoShadowColor = shadowColor == nil
            self?.shadowXOffsetView.isHidden = isNoShadowColor
            self?.shadowYOffsetView.isHidden = isNoShadowColor
        }
        viewModel.$shadowXOffset.sink { [textLabel] in
            textLabel.shadowOffset.width = $0
        }
        viewModel.$shadowYOffset.sink { [textLabel] in
            textLabel.shadowOffset.height = $0
        }

        textLabel.linkTapAction = { url in
            UIApplication.shared.open(url)
        }
        textLabel.linkLongPressAction = { [weak self] url in
            self?.showLinkActionSheet(for: url)
        }
    }

    private func showLinkActionSheet(for url: URL) {
        let actionSheetController = UIAlertController(
            title: url.absoluteString,
            message: nil,
            preferredStyle: .actionSheet
        )
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = url.absoluteString
        }
        actionSheetController.addAction(copyAction)
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheetController, animated: true)
    }
}
