//
//  ViewController.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 13/07/2023.
//

import RichTextLabel
import UIKit

final class ViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let textLabel = RichTextLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackgroundCompat
        setupLayout()
        setupTextLabel()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let inset: CGFloat = 20
        scrollView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        scrollView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: 2 * -inset)
        ])
    }

    private func setupTextLabel() {
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 21)
        textLabel.textColor = .labelCompat
        textLabel.textAlignment = .natural // just an example of use, the default value is already .natural

        textLabel.linkTapAction = { url in
            UIApplication.shared.open(url)
        }

        let text = """
        RichTextLabel supports all UILabel functionality as well as custom link handling: https://github.com/fffonoff/RichTextLabel
        """
        textLabel.text = text
    }
}
