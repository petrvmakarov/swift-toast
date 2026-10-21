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

struct ToastMessageView<LeftAccessory: View, RightAccessory: View>: View {
    var title: String?
    var message: String?
    var titleLinesLimit: Int?
    var messageLinesLimit: Int?
    var messageTitleSpacing: CGFloat?
    var cornerRadius: CGFloat
    var backgroundColor: Color
    var accessoryViewSpacing: CGFloat
    var liquidGlassEnabled: Bool

    private let leftAccessory: LeftAccessory
    private let rightAccessory: RightAccessory

    init(
        title: String? = nil,
        message: String? = nil,
        titleLinesLimit: Int? = nil,
        messageLinesLimit: Int? = nil,
        messageTitleSpacing: CGFloat? = nil,
        cornerRadius: CGFloat = defaultCornerRadius,
        backgroundColor: Color = defaultBackgroundColor,
        liquidGlassEnabled: Bool = false,
        accessoryViewSpacing: CGFloat = defaultAccessoryViewSpacing,
        @ViewBuilder leftAccessory: () -> LeftAccessory = { EmptyView() },
        @ViewBuilder rightAccessory: () -> RightAccessory = { EmptyView() },
    ) {
        self.title = title
        self.message = message
        self.titleLinesLimit = titleLinesLimit
        self.messageLinesLimit = messageLinesLimit
        self.messageTitleSpacing = messageTitleSpacing
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        
        self.liquidGlassEnabled = liquidGlassEnabled
        
        self.accessoryViewSpacing = accessoryViewSpacing
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    var body: some View {
        if #available(iOS 26.0, macOS 26.0, *), liquidGlassEnabled {
            liquidGlassBody
        }
        else {
            regularBody
        }
    }
    
    @available(iOS 26.0, macOS 26.0, *)
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

            VStack(alignment: .leading, spacing: messageTitleSpacing) {
                if let title {
                    Text(title)
                        .lineLimit(titleLinesLimit)
                }

                if let message {
                    Text(message)
                        .lineLimit(messageLinesLimit)
                }
            }

            Spacer(minLength: 0)

            rightAccessory
        }
        .padding()
    }
}

#Preview {
    ToastMessageView(
        title: "This is a title",
        message: "This is a message"
    )
    
    ToastMessageView(
        title: "This is a title",
        message: "This is a message",
        messageTitleSpacing: 15
    )
    
    ToastMessageView(
        title: "This is a title",
    )
    
    ToastMessageView(
        message: "This is a message"
    )
    
    ToastMessageView(
        title: "This is a title",
        message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
        messageLinesLimit: 3
    )
    
    ToastMessageView(
        title: "This is a title",
    )
    
    ToastMessageView(
        title: "Download complete",
        message: "report.pdf was saved",
        liquidGlassEnabled: true,
    ) {
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
