//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

public struct ToastType {
    private let render: @MainActor () -> AnyView

    private init(render: @escaping @MainActor () -> AnyView) {
        self.render = render
    }

    @MainActor
    public static func info(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message)
    }

    @MainActor
    public static func success(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message)
    }

    @MainActor
    public static func warning(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message)
    }

    @MainActor
    public static func error(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message)
    }

    @MainActor
    public static func custom<TData: Hashable>(
        _ data: TData,
        _ presentationOptions: ToastPresentationOptions<TData>
    ) -> ToastType {
        ToastType {
            AnyView(
                ToastMessageView(
                    presentationOptions.messageViewOptions,
                    message: { AnyView(presentationOptions.renderMessage(data)) },
                    leftAccessory: { AnyView(presentationOptions.renderLeftAccessory(data)) },
                    rightAccessory: { AnyView(presentationOptions.renderRightAccessory(data)) }
                )
            )
        }
    }

    @MainActor
    func renderView() -> AnyView {
        render()
    }

    @MainActor
    private static func predefined(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        ToastType {
            AnyView(
                ToastMessageView(
                    message: {
                        TitleAndMessageView(
                            title: title,
                            message: message
                        )
                    },
                    leftAccessory: { EmptyView() },
                    rightAccessory: { EmptyView() }
                )
            )
        }
    }
}


