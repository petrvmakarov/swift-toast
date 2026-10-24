//
//  ShowToastAction.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import Foundation
import SwiftUI

fileprivate let DEFAULT_DISMISS_TIMEOUT: TimeInterval = 2.0

struct AnyToastType {
    private let render: @MainActor () -> AnyView

    @MainActor
    init<TData: Hashable>(_ type: ToastType<TData>) {
        render = {
            switch type {
            case .custom(let data, let presentationOptions):
                return AnyView(
                    ToastMessageView(
                        presentationOptions.messageViewOptions,
                        message: { AnyView(presentationOptions.renderMessage(data)) },
                        leftAccessory: { AnyView(presentationOptions.renderLeftAccessory(data)) },
                        rightAccessory: { AnyView(presentationOptions.renderRightAccessory(data)) }
                    )
                )
            case .info(let titleAndMessage),
                 .success(let titleAndMessage),
                 .warning(let titleAndMessage),
                 .error(let titleAndMessage):
                return AnyView(
                    ToastMessageView(
                        message: {
                            TitleAndMessageView(
                                title: titleAndMessage.title,
                                message: titleAndMessage.message
                            )
                        },
                        leftAccessory: { EmptyView() },
                        rightAccessory: { EmptyView() }
                    )
                )
            }
        }
    }

    @MainActor
    func renderView() -> AnyView {
        render()
    }
}

struct ShowToastAction {
    typealias Action = (AnyToastType, ToastPlacement, TimeInterval) -> Void
    let action: Action

    @MainActor
    func callAsFunction<TData: Hashable>(
        _ type: ToastType<TData>,
        placement: ToastPlacement = .top,
        dismissAfter: TimeInterval = DEFAULT_DISMISS_TIMEOUT
    ) {
        action(AnyToastType(type), placement, dismissAfter)
    }
}
