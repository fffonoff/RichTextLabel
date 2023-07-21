//
//  AttributeGroupTitleView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 21/07/2023.
//

import SwiftUI

struct AttributeGroupTitleView: View {

    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.gray)
            .frame(height: 32)
    }
}
