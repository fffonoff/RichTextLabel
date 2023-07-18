//
//  ContentView.swift
//  RichTextLabelExample
//
//  Created by Roman Trifonov on 17/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExampleView()
                .tabItem {
                    let exampleTabLabel = Label("Example", systemImage: "doc.plaintext")
                    if #available(iOS 15.0, *) {
                        exampleTabLabel
                            .environment(\.symbolVariants, .none)
                    } else {
                        exampleTabLabel
                    }
                }
            LivePreviewView()
                .tabItem {
                    Label("Live Preview", systemImage: "slider.horizontal.3")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
