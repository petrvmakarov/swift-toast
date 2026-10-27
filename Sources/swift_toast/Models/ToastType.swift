//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

fileprivate extension ToastOptions {
    static var error: ToastOptions {
        ToastOptions(
            iconSystemName: "checkmark.circle.fill",
            iconColor: .red,
            
            buttonSystemName: "xmark",
            buttonTint: .red,
        )
    }
    
    static var warning: ToastOptions {
        ToastOptions(
            iconSystemName: "checkmark.circle.fill",
            iconColor: .orange,
            
            buttonSystemName: "xmark",
            buttonTint: .orange,
        )
    }
    
    static var success: ToastOptions {
        ToastOptions(
            iconSystemName: "checkmark.circle.fill",
            iconColor: .green,
            
            buttonSystemName: "xmark",
            buttonTint: .green,
        )
    }
    
    static var info: ToastOptions {
        ToastOptions(
            iconSystemName: "checkmark.circle.fill",
            iconColor: .accentColor,
            
            buttonSystemName: "xmark",
            buttonTint: .accentColor,
        )
    }
}

public struct ToastType {
    private let render: @MainActor () -> AnyView

    private init(
        render: @escaping @MainActor () -> AnyView
    ) {
        self.render = render
    }

    @MainActor
    public static func info(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: UserToastOptions? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   options: ToastOptions.info.merge(with: options))
    }

    @MainActor
    public static func success(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: UserToastOptions? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   options: ToastOptions.success.merge(with: options))
    }

    @MainActor
    public static func warning(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: UserToastOptions? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   options: ToastOptions.warning.merge(with: options))
    }

    @MainActor
    public static func error(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: UserToastOptions? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   options: ToastOptions.error.merge(with: options))
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
    private static func predefined(title: StringProtocol? = nil, message: StringProtocol? = nil, options: ToastOptions) -> ToastType {
        print("options.isLiquidGlassEnabled=\(options.isLiquidGlassEnabled)")
        return ToastType {
            AnyView(
                ToastMessageView(
                    ToastMessageViewOptions(backgroundColor: options.background, liquidGlassEnabled: options.isLiquidGlassEnabled),
                    message: {
                        TitleAndMessageView(
                            title: title,
                            message: message,
                            messageTitleSpacing: 0,
                            titleColor: options.titleColor,
                            messageColor: options.messageColor,
                        )
                    },
                    leftAccessory: {
                        ImageAccessory(.systemName(options.iconSystemName), withOptions: .init(forgroundColor: options.iconColor))
                    },
                    rightAccessory: {
                        DismissImageButton(
                            .systemName(options.buttonSystemName),
                            withOptions: .init(forgroundColor: options.buttonTint, backgroundColor: options.buttonBackground)
                        )
                    }
                )
            )
        }
    }
}
