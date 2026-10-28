//
//  ToastOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//

import SwiftUI

struct ColorWithLiquidGlass {
    var regular: Color
    var liquidGlass: Color
    
    enum colorType {
        case regular
        case liquidGlass
    }
    
    func getColor(for liquidGlassEnabled: Bool) -> Color {
        liquidGlassEnabled && SystemHelper.isLiquidGlassAvailable() ? liquidGlass : regular
    }
}

package struct ToastOptions {
    var iconSystemName: String
    var iconColor: Color
    
    var buttonSystemName: String
    var buttonTint: Color
    var buttonBackground: Color? = nil
    
    var titleFont: Font
    var titleColor: ColorWithLiquidGlass
    
    var messageFont: Font
    var messageColor: ColorWithLiquidGlass
    
    var background: ColorWithLiquidGlass
    
    var liquidGlassEnabled: Bool
    
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
        titleColor: ColorWithLiquidGlass(
            regular: .white,
            liquidGlass: .primary
        ),
        messageFont: .footnote,
        messageColor: ColorWithLiquidGlass(
            regular: .white,
            liquidGlass: .primary
        ),
        background: ColorWithLiquidGlass(
            regular: K.Defaults.backgroundRegular,
            liquidGlass: K.Defaults.backgroundLiquidGlass
        ),
        liquidGlassEnabled: K.Defaults.liquidGlassEnabled,
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
        titleColor: ColorWithLiquidGlass? = nil,
        messageFont: Font? = nil,
        messageColor: ColorWithLiquidGlass? = nil,
        background: ColorWithLiquidGlass? = nil,
        liquidGlassEnabled: Bool? = nil
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
        self.liquidGlassEnabled = liquidGlassEnabled ?? Self.default.liquidGlassEnabled
     
    }
}


