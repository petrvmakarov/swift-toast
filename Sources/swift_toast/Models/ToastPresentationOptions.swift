//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI


struct TitleAndMessage {
    let title: StringProtocol? = nil
    let message: StringProtocol? = nil
}

@MainActor
@ViewBuilder
func renderTitleAndMessageView(_ data: Any) -> some View {
    if let titleAndMessage = data as? TitleAndMessage {
        TitleAndMessageView(
            title: titleAndMessage.title,
            message: titleAndMessage.message
        )
    }
}
 
struct ToastPresentationOptions<TData: Hashable> {
    let messageViewOptions: ToastMessageViewOptions
    let renderMessage: @MainActor (_ data: TData) -> any View
    let renderLeftAccessory: @MainActor (_ data: TData) -> any View
    let renderRightAccessory: @MainActor (_ data: TData) -> any View

    init(
        messageViewOptions: ToastMessageViewOptions = ToastMessageViewOptions.default,
        renderMessage: @escaping @MainActor (_ data: TData) -> any View,
        renderLeftAccessory: @escaping @MainActor (_ data: TData) -> any View = { _ in EmptyView() },
        renderRightAccessory: @escaping @MainActor (_ data: TData) -> any View = { _ in EmptyView() }
    ) {
        self.messageViewOptions = messageViewOptions
        self.renderMessage = renderMessage
        self.renderLeftAccessory = renderLeftAccessory
        self.renderRightAccessory = renderRightAccessory
    }
}





