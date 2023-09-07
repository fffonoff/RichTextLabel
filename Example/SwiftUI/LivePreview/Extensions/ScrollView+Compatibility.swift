//
//  ScrollView+Compatibility.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 03/09/2023.
//

import SwiftUI

extension ScrollView {
    func scrollBounceBasedOnSize() -> some View {
        if #available(iOS 16.4, *) {
            return scrollBounceBehavior(.basedOnSize)
        }

        return self
    }
}
