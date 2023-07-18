//
//  NumericAttributeView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 18/07/2023.
//

import SwiftUI

struct NumericAttributeView: View {

    let titleFormat: String
    let range: ClosedRange<Double>
    let value: Binding<Double>

    var body: some View {
        Stepper(value: value, in: range, step: 1) {
            Text(String(format: titleFormat, value.wrappedValue))
        }
    }
}

extension NumericAttributeView {
    init(_ description: NumericAttributeDescription, value: Binding<Double>) {
        titleFormat = description.titleFormat
        range = description.range
        self.value = value
    }
}
