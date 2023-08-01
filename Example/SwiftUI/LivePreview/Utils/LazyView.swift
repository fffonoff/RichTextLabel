//
//  LazyView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 01/08/2023.
//

import SwiftUI

struct LazyView<Content: View>: View {

    let contentBuilder: () -> Content

    init(_ contentBuilder: @autoclosure @escaping () -> Content) {
        self.contentBuilder = contentBuilder
    }

    var body: Content {
        contentBuilder()
    }
}
