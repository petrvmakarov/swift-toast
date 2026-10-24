//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 19/10/2026.
//

import SwiftUI

private let defaultCornerRadius: CGFloat = 32
private let defaultBackgroundColor: Color = .gray
private let defaultAccessoryViewSpacing: CGFloat = 12

struct ToastMessageView<
    Message: View,
    LeftAccessory: View,
    RightAccessory: View
>: View {
    
    var cornerRadius: CGFloat
    var backgroundColor: Color
    var accessoryViewSpacing: CGFloat
    var liquidGlassEnabled: Bool
    
    private let message: Message
    private let leftAccessory: LeftAccessory
    private let rightAccessory: RightAccessory
    
    init(
        cornerRadius: CGFloat = defaultCornerRadius,
        backgroundColor: Color = defaultBackgroundColor,
        liquidGlassEnabled: Bool = false,
        accessoryViewSpacing: CGFloat = defaultAccessoryViewSpacing,
        @ViewBuilder message: () -> Message = { EmptyView() },
        @ViewBuilder leftAccessory: () -> LeftAccessory = { EmptyView() },
        @ViewBuilder rightAccessory: () -> RightAccessory = { EmptyView() },
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        
        self.liquidGlassEnabled = liquidGlassEnabled
        
        self.message = message()
        
        self.accessoryViewSpacing = accessoryViewSpacing
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *), liquidGlassEnabled {
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
                    .tint(backgroundColor)
                    .interactive(),
                in: .rect(cornerSize: .init(width: cornerRadius, height: cornerRadius)))
            .shadow(radius: 3)
    }
    
    private var regularBody: some View {
        internalBody
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            }
    }
    
    private var internalBody: some View {
        HStack(spacing: accessoryViewSpacing) {
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
    
    ToastMessageView(liquidGlassEnabled: true) {
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
    
    ToastMessageView(liquidGlassEnabled: true) {
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
