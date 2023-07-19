//
//  UIKitActionSheetHelper.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 19/07/2023.
//

import UIKit

struct UIKitActionSheetHelper {
    func showActionSheet(withTitle title: String, actions: [UIAlertAction], isCancellable: Bool = true) {
        let actionSheetController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        actions.forEach { actionSheetController.addAction($0) }
        if isCancellable {
            actionSheetController.addAction(UIAlertAction(title: "Сancel", style: .cancel))
        }

        let windowScene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        window?.rootViewController?.present(actionSheetController, animated: true)
    }
}
