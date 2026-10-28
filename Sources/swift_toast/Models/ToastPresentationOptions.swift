//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

public struct TitleAndMessage {
    let title: (any StringProtocol)?
    let message: (any StringProtocol)?

    public init(
        title: (any StringProtocol)? = nil,
        message: (any StringProtocol)? = nil
    ) {
        self.title = title
        self.message = message
    }
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

public struct ToastPresentationOptions<TData: Hashable> {
    let messageViewOptions: ToastContainerViewOptions
    let renderMessage: @MainActor (_ data: TData) -> any View
    let renderLeftAccessory: @MainActor (_ data: TData) -> any View
    let renderRightAccessory: @MainActor (_ data: TData) -> any View

    public init(
        messageViewOptions: ToastContainerViewOptions = ToastContainerViewOptions.default,
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
