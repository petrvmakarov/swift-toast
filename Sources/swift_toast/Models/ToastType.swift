//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

// TODO: Move to constants
fileprivate let defaultIsLiquidGlassEnabled: Bool = true

struct ToastOptions {
    var iconSystemName: String
    var iconColor: Color
    
    var buttonSystemName: String
    var buttonTint: Color
    var buttonBackground: Color? = nil
    
    var titleFont: Font
    var titleColor: Color
    
    var messageFont: Font
    var messageColor: Color
    
    var background: Color
    
    var isLiquidGlassEnabled: Bool
    
    private static func evaluateDefaultBackgroundColor(isLiquidGlassEnabled: Bool) -> Color {
        if SystemHelper.isLiquidGlassAvailable() && isLiquidGlassEnabled {
            return .clear
        }
        return Color.adaptive(light: "#0C0F1A", lightOpacity: 0.66, dark: "#FFFFFF", darkOpacity: 0.48)
    }
    
    private static func evaluateDefaultTitleColor(isLiquidGlassEnabled: Bool) -> Color {
        if SystemHelper.isLiquidGlassAvailable() && isLiquidGlassEnabled {
            return .primary
        }
        return .white
    }
    
    private static func evaluateDefaultMessageColor(isLiquidGlassEnabled: Bool) -> Color {
        if SystemHelper.isLiquidGlassAvailable() && isLiquidGlassEnabled {
            return .primary
        }
        return .white
    }
    
    public static var `default`: ToastOptions { ToastOptions(
        iconSystemName: "",
        iconColor: .accentColor,
        buttonSystemName: "xmark",
        buttonTint: .accentColor,
        buttonBackground: nil,
        titleFont: .footnote.bold(),
        titleColor: evaluateDefaultTitleColor(isLiquidGlassEnabled: defaultIsLiquidGlassEnabled),
        messageFont: .footnote,
        messageColor: evaluateDefaultMessageColor(isLiquidGlassEnabled: defaultIsLiquidGlassEnabled),
        background: evaluateDefaultBackgroundColor(isLiquidGlassEnabled: defaultIsLiquidGlassEnabled),
        isLiquidGlassEnabled: defaultIsLiquidGlassEnabled,
    ) }
    
    init(
        iconSystemName: String? = nil,
        iconColor: Color? = nil,
        buttonSystemName: String? = nil,
        buttonTint: Color? = nil,
        buttonBackground: Color? = nil,
        titleFont: Font? = nil,
        titleColor: Color? = nil,
        messageFont: Font? = nil,
        messageColor: Color? = nil,
        background: Color? = nil,
        isLiquidGlassEnabled: Bool? = nil
    ) {
        self.iconSystemName = iconSystemName ?? Self.default.iconSystemName
        self.iconColor = iconColor ?? Self.default.iconColor
        self.buttonSystemName = buttonSystemName ?? ToastOptions.default.buttonSystemName
        self.buttonTint = buttonTint ?? Self.default.buttonTint
        self.buttonBackground = buttonBackground// ?? Self.default.buttonBackground
        self.titleFont = titleFont ?? Self.default.titleFont
        self.titleColor = titleColor ?? Self.default.titleColor
        self.messageFont = messageFont ?? Self.default.messageFont
        self.messageColor = messageColor ?? Self.default.messageColor
        self.background = background ?? Self.default.background
        self.isLiquidGlassEnabled = isLiquidGlassEnabled ?? Self.default.isLiquidGlassEnabled
     
    }
}

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
    public static func info(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message, options: ToastOptions.info)
    }

    @MainActor
    public static func success(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message, options: ToastOptions.success)
    }

    @MainActor
    public static func warning(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message, options: ToastOptions.warning)
    }

    @MainActor
    public static func error(title: StringProtocol? = nil, message: StringProtocol? = nil) -> ToastType {
        predefined(title: title, message: message, options: ToastOptions.error)
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
        print("options=\(options)")
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
