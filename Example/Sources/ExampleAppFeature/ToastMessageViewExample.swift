//
//  ToastMessageViewExample.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI
import swift_toast

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
            Button {
               // showToast(.info(title: "hello", message: "from toast"))
                showToast(.showString("custom text"), placement: .top, dismissAfter: 10)
            } label: {
                Text("Press me")
            }
        }.overlay(alignment: .bottom) {
//            ToastMessageView {
//                TitleAndMessageView(
//                    title: "This is a title",
//                    message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
//                    messageLinesLimit: 3
//                )
//            }.shadow(radius: 5)
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
