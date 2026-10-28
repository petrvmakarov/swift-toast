//
//  UserToastOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//


import SwiftUI

public struct UserToastOptions {
    public struct ContainerOverrides {
        var cornerRadius: CGFloat?
        var internalSpacing: CGFloat?
        var externalSpacing: CGFloat?
        var stretched: Bool?
        // FIXME: this prop doesnt make any effect if liquid glass is on
        var ignoreSafeArea: Edge.Set?

        public init(
            cornerRadius: CGFloat? = nil,
            internalSpacing: CGFloat? = nil,
            externalSpacing: CGFloat? = nil,
            stretched: Bool? = nil,
            ignoreSafeArea: Edge.Set? = nil
        ) {
            self.cornerRadius = cornerRadius
            self.internalSpacing = internalSpacing
            self.externalSpacing = externalSpacing
            self.stretched = stretched
            self.ignoreSafeArea = ignoreSafeArea
        }
    }

    var iconSystemName: String? = nil
    var iconColor: Color? = nil
    
    var buttonSystemName: String? = nil
    var buttonTint: Color? = nil
    var buttonBackground: Color? = nil
    
    var titleFont: Font? = nil
    var titleColor: Color? = nil
     
    var messageFont: Font? = nil
    var messageColor: Color? = nil
    
    var background: Color? = nil
    
    var liquidGlassEnabled: Bool? = nil
    var container: ContainerOverrides = .init()
    
    var onTap: (() -> Void)? = nil

    public init(
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
        liquidGlassEnabled: Bool? = nil,
        stretched: Bool? = nil,
        container: ContainerOverrides = .init(),
        onTap: (() -> Void)? = nil
    ) {
        self.iconSystemName = iconSystemName
        self.iconColor = iconColor
        self.buttonSystemName = buttonSystemName
        self.buttonTint = buttonTint
        self.buttonBackground = buttonBackground
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.background = background
        self.liquidGlassEnabled = liquidGlassEnabled
        self.container = ContainerOverrides(
            cornerRadius: container.cornerRadius,
            internalSpacing: container.internalSpacing,
            externalSpacing: container.externalSpacing,
            stretched: container.stretched ?? stretched,
            ignoreSafeArea: container.ignoreSafeArea
        )
        self.onTap = onTap
    }
    
    private static func evaluateColorWithLiquidGlass(_ value: Color?, fallback: ColorWithLiquidGlass) -> ColorWithLiquidGlass {
        if let value {
            return ColorWithLiquidGlass(
                regular: value, liquidGlass: value
            )
        }
        return fallback
    }
    
    func applying(to defaults: ToastOptions) -> ToastOptions {
        ToastOptions(
            iconSystemName: iconSystemName ?? defaults.iconSystemName,
            iconColor: iconColor ?? defaults.iconColor,
            buttonSystemName: buttonSystemName ?? defaults.buttonSystemName,
            buttonTint: buttonTint ?? defaults.buttonTint,
            buttonBackground: buttonBackground ?? defaults.buttonBackground,
            titleFont: titleFont ?? defaults.titleFont,
            titleColor: Self.evaluateColorWithLiquidGlass(titleColor, fallback: defaults.titleColor),
            messageFont: messageFont ?? defaults.messageFont,
            messageColor: Self.evaluateColorWithLiquidGlass(messageColor, fallback: defaults.messageColor),
            background: Self.evaluateColorWithLiquidGlass(background, fallback: defaults.background),
            liquidGlassEnabled: liquidGlassEnabled ?? defaults.liquidGlassEnabled
        )
    }
}
