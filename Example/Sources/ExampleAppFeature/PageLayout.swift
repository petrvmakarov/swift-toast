//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftUI

struct PageLayout<Content: View>: View {
    private var title: String? = nil
    private var instructions: String? = nil
    private var code: String
    private var codeMaxHeight: CGFloat? = nil

    private let content: Content

    package init(title: String? = nil,
                 instructions: String? = nil,
                 code: String,
                 codeMaxHeight: CGFloat? = nil,
                 @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.title = title
        self.instructions = instructions
        self.code = code
        self.codeMaxHeight = codeMaxHeight
        self.content = content()
    }
    
    var body: some View {
        VStack {
            if let title, !title.isEmpty {
                Header(title)
            }
            if let instructions, !instructions.isEmpty {
                Text(instructions)
                    .font(.body)
            }
            CodeView(code: code)
                .frame(height: codeMaxHeight)
            content
        }
        .padding()
    }
}

#Preview {
    PageLayout(title: "Hello World", code: """
        import Foundation
        
        func main() {
            print("Hello world!")
        }
        """) {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
