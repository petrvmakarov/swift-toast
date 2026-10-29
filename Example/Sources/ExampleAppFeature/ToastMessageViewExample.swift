//
//  ToastMessageViewExample.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI
import SwiftToast

public struct ToastMessageViewExample: View {
    @Environment(\.showToast) private var showToast
    
    public init() {}
    
    public var body: some View {
        VStack {
            ToastContainerView {
                TitleAndMessageView(
                    title: "This is a title",
                    message: "This is a message"
                )
            }
            
            ToastContainerView {
                TitleAndMessageView(
                    title: "This is a title",
                    message: "This is a message",
                    messageTitleSpacing: 15
                )
            }
            
            ToastContainerView(ToastContainerViewOptions(liquidGlassEnabled: true)) {
                TitleAndMessageView(title: "This is a title")
            }
            
            ToastContainerView {
                TitleAndMessageView(message: "This is a message")
            }
            
            ToastContainerView {
                TitleAndMessageView(
                    title: "This is a title",
                    message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
                    messageLinesLimit: 3
                )
            }
        }.overlay(alignment: .bottom) {
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ToastMessageViewExample()
        Spacer()
    }
    .withToast()
}
