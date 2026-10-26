//
//  TitleAndMessageView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

package struct TitleAndMessageView: View {
    var title: any StringProtocol? = nil
    var message: any StringProtocol? = nil
    var titleLinesLimit: Int? = nil
    var messageLinesLimit: Int? = nil
    var messageTitleSpacing: CGFloat? = nil
    var titleColor: Color = .primary
    var messageColor: Color = .primary

    package init(
        title: (any StringProtocol)? = nil,
        message: (any StringProtocol)? = nil,
        titleLinesLimit: Int? = nil,
        messageLinesLimit: Int? = nil,
        messageTitleSpacing: CGFloat? = nil,
        titleColor: Color = .primary,
        messageColor: Color = .primary
    ) {
        self.title = title
        self.message = message
        self.titleLinesLimit = titleLinesLimit
        self.messageLinesLimit = messageLinesLimit
        self.messageTitleSpacing = messageTitleSpacing
        self.titleColor = titleColor
        self.messageColor = messageColor
    }
    
    package var body: some View {
        VStack(alignment: .leading, spacing: messageTitleSpacing) {
            if let title {
                Text(title)
                    .foregroundStyle(titleColor)
                    .bold()
                    .font(.footnote)
                    .lineLimit(titleLinesLimit)
            }
            if let message {
                Text(message)
                    .foregroundStyle(messageColor)
                    .font(.footnote)
                    .lineLimit(messageLinesLimit)
            }
        }
    }
}

#Preview {
    TitleAndMessageView(
        title: "This is a title",
        message: "This is a message"
    )
    
    TitleAndMessageView(
        title: "This is a title",
        message: "This is a message",
        messageTitleSpacing: 15
    )
    
    TitleAndMessageView(
        title: "This is a title",
    )
    
    TitleAndMessageView(
        message: "This is a message"
    )
    
    TitleAndMessageView(
        title: "This is a title",
        message: "This is a message a long long looooooooooooooooooooooooooooooong message long long long long long long long long long long long long long long long long message",
        messageLinesLimit: 3
    )
}
