//
//  LivePreviewModule.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 01/08/2023.
//

import SwiftUI

struct LivePreviewModule {
    var view: some View {
        LazyView(LivePreviewView(viewModel: LivePreviewViewModel(pasteBoardHelper: UIKitPasteBoardHelper())))
    }
}
