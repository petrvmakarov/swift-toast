//
//  UserToastOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//


import SwiftUI

public struct UserToastOptions {
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
    
    var isLiquidGlassEnabled: Bool? = nil

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
        isLiquidGlassEnabled: Bool? = nil
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
        self.isLiquidGlassEnabled = isLiquidGlassEnabled
    }
    
    func applying(to defaults: ToastOptions) -> ToastOptions {
        ToastOptions(
            iconSystemName: iconSystemName ?? defaults.iconSystemName,
            iconColor: iconColor ?? defaults.iconColor,
            buttonSystemName: buttonSystemName ?? defaults.buttonSystemName,
            buttonTint: buttonTint ?? defaults.buttonTint,
            buttonBackground: buttonBackground ?? defaults.buttonBackground,
            titleFont: titleFont ?? defaults.titleFont,
            titleColor: titleColor ?? defaults.titleColor,
            messageFont: messageFont ?? defaults.messageFont,
            messageColor: messageColor ?? defaults.messageColor,
            background: background ?? defaults.background,
            isLiquidGlassEnabled: isLiquidGlassEnabled ?? defaults.isLiquidGlassEnabled
        )
    }
}
