//
//  PasteBoardHelper.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 31/07/2023.
//

import UIKit

protocol PasteBoardHelper {
    var hasStrings: Bool { get }
    var string: String? { get nonmutating set }
}

struct UIKitPasteBoardHelper: PasteBoardHelper {

    var hasStrings: Bool { UIPasteboard.general.hasStrings }

    var string: String? {
        get { UIPasteboard.general.string }
        nonmutating set { UIPasteboard.general.string = newValue }
    }
}

struct PasteBoardHelper_Preview: PasteBoardHelper {

    let hasStrings = true

    var string: String? {
        get { "Preview test" }
        nonmutating set { }
    }
}
