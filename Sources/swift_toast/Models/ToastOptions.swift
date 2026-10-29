//
//  ToastOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//

import SwiftUI

package struct ColorWithLiquidGlass {
    package var regular: Color
    package var liquidGlass: Color
    
    package func getColor(for liquidGlassEnabled: Bool) -> Color {
        liquidGlassEnabled && K.isLiquidGlassAvailable ? liquidGlass : regular
    }
}

package struct ToastOptions {
    package var iconSystemName: String
    package var iconColor: Color
    
    package var buttonSystemName: String
    package var buttonTint: Color
    package var buttonBackground: Color? = nil
    
    package var titleFont: Font
    package var titleColor: ColorWithLiquidGlass
    
    package var messageFont: Font
    package var messageColor: ColorWithLiquidGlass
    
    package var background: ColorWithLiquidGlass
    
    package var liquidGlassEnabled: Bool
    
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
    
    public func merge(with options: ToastConfiguration?) -> ToastOptions {
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


