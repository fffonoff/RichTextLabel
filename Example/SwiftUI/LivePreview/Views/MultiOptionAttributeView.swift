//
//  MultiOptionAttributeView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 19/07/2023.
//

import SwiftUI

struct AttributeOption<Value: Equatable> {
    let title: String
    let value: Value
}

struct MultiOptionAttributeView<Value: Equatable>: View {

    let title: String
    let options: [AttributeOption<Value>]
    @Binding var selection: Value

    @State private var selectedOption: AttributeOption<Value>? {
        didSet {
            if let selectedOption {
                selection = selectedOption.value
            }
        }
    }

    private let uiKitActionSheethelper = UIKitActionSheetHelper()

    init(title: String, options: [AttributeOption<Value>], selection: Binding<Value>) {
        self.title = title
        self.options = options
        _selection = selection
        let defaultOption = options.first { selection.wrappedValue == $0.value }
        _selectedOption = State(initialValue: defaultOption)
    }

    var body: some View {
        HStack {
            Text("\(title):")
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(selectedOption?.title ?? "None") {
                uiKitActionSheethelper.showActionSheet(
                    withTitle: "Select \(title.lowercased()):",
                    actions: options.map { option in
                        let action = UIAlertAction(title: option.title) { _ in
                            selectedOption = option
                        }
                        action.isChecked = selectedOption?.value == option.value
                        action.titleTextColor = (option.value as? UIColor)?.withAlphaComponent(1)
                        return action
                    }
                )
            }
            .foregroundColor((selectedOption?.value as? UIColor)?.withAlphaComponent(1).color ?? .primary)
        }
        .frame(height: 32)
    }
}

extension MultiOptionAttributeView {
    init(_ description: MultiOptionAttributeDescription<Value>, selection: Binding<Value>) {
        self.init(title: description.title, options: description.options, selection: selection)
    }
}
