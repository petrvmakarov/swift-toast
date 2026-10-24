//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 19/10/2026.
//

import SwiftUI

struct ToastMessageView<
    Message: View,
    LeftAccessory: View,
    RightAccessory: View
>: View {

    private let options: ToastMessageViewOptions
    private let message: Message
    private let leftAccessory: LeftAccessory
    private let rightAccessory: RightAccessory
    
    init(
        _ options: ToastMessageViewOptions = ToastMessageViewOptions.default,
        @ViewBuilder message: () -> Message = { EmptyView() },
        @ViewBuilder leftAccessory: () -> LeftAccessory = { EmptyView() },
        @ViewBuilder rightAccessory: () -> RightAccessory = { EmptyView() },
    ) {
        self.options = options
        self.message = message()
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *), options.liquidGlassEnabled {
            liquidGlassBody
        }
        else {
            regularBody
        }
    }
    
    @available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0, *)
    private var liquidGlassBody: some View {
        internalBody
            .glassEffect(
                .clear
                    .tint(options.backgroundColor)
                    .interactive(),
                in: .rect(cornerSize: .init(width: options.cornerRadius, height: options.cornerRadius)))
            .shadow(radius: 3)
    }
    
    private var regularBody: some View {
        internalBody
            .background {
                RoundedRectangle(cornerRadius: options.cornerRadius)
                    .fill(options.backgroundColor)
            }
    }
    
    private var internalBody: some View {
        HStack(spacing: options.accessoryViewSpacing) {
            leftAccessory
            
            message
            
            Spacer(minLength: 0)
            
            rightAccessory
        }
        .padding()
    }
}

#Preview {
    ToastMessageView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message"
        )
    }
    
    ToastMessageView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message",
            messageTitleSpacing: 15
        )
    }
    
    ToastMessageView(ToastMessageViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(title: "This is a title")
    }
    
    ToastMessageView {
        TitleAndMessageView(message: "This is a message")
    }
    
    ToastMessageView {
        TitleAndMessageView(
            title: "This is a title",
            message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
            messageLinesLimit: 3
        )
    }
    
    ToastMessageView {
        TitleAndMessageView(
            title: "This is a title",
        )
    }
    
    ToastMessageView(ToastMessageViewOptions(liquidGlassEnabled: true)) {
        TitleAndMessageView(
            title: "Download complete",
            message: "report.pdf was saved",
        )
    } leftAccessory: {
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.black)
    } rightAccessory: {
        Button {
            // Dismiss toast
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
        }
    }
}
