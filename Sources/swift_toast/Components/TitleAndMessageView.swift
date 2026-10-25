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

    package init(
        title: (any StringProtocol)? = nil,
        message: (any StringProtocol)? = nil,
        titleLinesLimit: Int? = nil,
        messageLinesLimit: Int? = nil,
        messageTitleSpacing: CGFloat? = nil
    ) {
        self.title = title
        self.message = message
        self.titleLinesLimit = titleLinesLimit
        self.messageLinesLimit = messageLinesLimit
        self.messageTitleSpacing = messageTitleSpacing
    }
    
    package var body: some View {
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
