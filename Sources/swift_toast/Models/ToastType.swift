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
            iconSystemName: "wrongwaysign",
            iconColor: .red,
            buttonSystemName: "xmark",
            buttonTint: .red,
        )
    }
    
    static var warning: ToastOptions {
        ToastOptions(
            iconSystemName: "exclamationmark.circle",
            iconColor: .orange,
            buttonSystemName: "xmark",
            buttonTint: .orange,
        )
    }
    
    static var success: ToastOptions {
        ToastOptions(
            iconSystemName: "checkmark.circle",
            iconColor: .green,
            buttonSystemName: "xmark",
            buttonTint: .green,
        )
    }
    
    static var info: ToastOptions {
        ToastOptions(
            iconSystemName: "info.circle",
            iconColor: .accentColor,
            buttonSystemName: "xmark",
            buttonTint: .accentColor,
        )
    }
}

public struct ToastType {
    private let render: @MainActor () -> AnyView
    let id: UUID
    
    private init(
        render: @escaping @MainActor () -> AnyView
    ) {
        self.render = render
        self.id = UUID()
    }

    @MainActor
    public static func info(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: ToastConfiguration? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   onTap: options?.onTap,
                   container: options?.container,
                   options: ToastOptions.info.merge(with: options))
    }

    @MainActor
    public static func success(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: ToastConfiguration? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   onTap: options?.onTap,
                   container: options?.container,
                   options: ToastOptions.success.merge(with: options))
    }

    @MainActor
    public static func warning(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: ToastConfiguration? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   onTap: options?.onTap,
                   container: options?.container,
                   options: ToastOptions.warning.merge(with: options))
    }

    @MainActor
    public static func error(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        options: ToastConfiguration? = nil
    ) -> ToastType {
        predefined(title: title,
                   message: message,
                   onTap: options?.onTap,
                   container: options?.container,
                   options: ToastOptions.error.merge(with: options))
    }

    @MainActor
    public static func custom<TData: Hashable>(
        _ data: TData,
        _ presentationOptions: ToastPresentationOptions<TData>
    ) -> ToastType {
        ToastType {
            AnyView(
                ToastContainerView(
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
    private static func predefined(
        title: StringProtocol? = nil,
        message: StringProtocol? = nil,
        onTap: (() -> Void)? = nil,
        container: ToastConfiguration.ContainerOverrides? = nil,
        options: ToastOptions) -> ToastType {
        return ToastType {
            AnyView(
                ToastContainerView(
                    ToastContainerViewOptions(
                        cornerRadius: container?.cornerRadius,
                        backgroundColor: options.background.getColor(for: options.liquidGlassEnabled),
                        internalSpacing: container?.internalSpacing,
                        externalSpacing: container?.externalSpacing,
                        liquidGlassEnabled: options.liquidGlassEnabled,
                        stretched: container?.stretched,
                        ignoreSafeArea: container?.ignoreSafeArea
                    ),
                    message: {
                        TitleAndMessageView(
                            title: title,
                            message: message,
                            messageTitleSpacing: 0,
                            titleColor: options.titleColor.getColor(for: options.liquidGlassEnabled),
                            messageColor: options.messageColor.getColor(for: options.liquidGlassEnabled),
                            titleFont: options.titleFont,
                            messageFont: options.messageFont,
                        )
                    },
                    leftAccessory: {
                        ImageAccessory(.systemName(options.iconSystemName), withOptions: .init(foregroundColor: options.iconColor))
                    },
                    rightAccessory: {
                        if let onTap {
                            ImageButton(
                                .systemName(options.buttonSystemName),
                                withOptions: .init(foregroundColor: options.buttonTint, backgroundColor: options.buttonBackground)
                            ) {
                                onTap()
                            }
                        } else {
                            DismissImageButton(
                                .systemName(options.buttonSystemName),
                                withOptions: .init(foregroundColor: options.buttonTint, backgroundColor: options.buttonBackground)
                            )
                        }
                    }
                )
            )
        }
    }
}
