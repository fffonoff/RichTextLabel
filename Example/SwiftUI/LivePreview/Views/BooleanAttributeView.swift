//
//  BooleanAttributeView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 21/07/2023.
//

import SwiftUI

struct BooleanAttributeView: View {

    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle("\(title):", isOn: $isOn)
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .frame(height: 32)
    }
}

extension BooleanAttributeView {
    init(_ description: BooleanAttributeDescription, isOn: Binding<Bool>) {
        title = description.title
        _isOn = isOn
    }
}
