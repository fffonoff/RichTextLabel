//
//  ViewController.swift
//  RichTextLabelUIKit
//
//  Created by Roman Trifonov on 13/07/2023.
//

import UIKit

final class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let exampleViewController = ExampleViewController()
        exampleViewController.tabBarItem = UITabBarItem(title: "Example", image: nil, tag: 0)
        if #available(iOS 13.0, *) {
            exampleViewController.tabBarItem.image = UIImage(systemName: "doc.plaintext")
        }

        let livePreviewViewController = LivePreviewViewController()
        livePreviewViewController.tabBarItem = UITabBarItem(title: "Live Preview", image: nil, tag: 1)
        if #available(iOS 13.0, *) {
            livePreviewViewController.tabBarItem.image = UIImage(systemName: "slider.horizontal.3")
        }

        viewControllers = [
            exampleViewController,
            livePreviewViewController
        ]
    }
}
