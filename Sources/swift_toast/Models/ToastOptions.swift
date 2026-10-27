//
//  ToastOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//

import SwiftUI

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
            return K.Defaults.backgroundLiquidGlass
        }
        return K.Defaults.backgroundRegular
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
        titleColor: evaluateDefaultTitleColor(isLiquidGlassEnabled: K.Defaults.liquidGlassEnabled),
        messageFont: .footnote,
        messageColor: evaluateDefaultMessageColor(isLiquidGlassEnabled: K.Defaults.liquidGlassEnabled),
        // FIXME: background value depends on initial K.Defaults.liquidGlassEnabled value
        background: evaluateDefaultBackgroundColor(isLiquidGlassEnabled: K.Defaults.liquidGlassEnabled),
        isLiquidGlassEnabled: K.Defaults.liquidGlassEnabled,
    ) }
    
    public func merge(with options: UserToastOptions?) -> ToastOptions {
        guard let options else {
            return self
        }
        return options.applying(to: self)
    }
    
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


