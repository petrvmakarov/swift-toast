//
//  ToastMessageViewOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

fileprivate let isLiquidGlassAvailable = SystemHelper.isLiquidGlassAvailable()

public struct ToastMessageViewOptions {
    public static var `default`: ToastMessageViewOptions { ToastMessageViewOptions() }

    public var cornerRadius: CGFloat
    public var backgroundColor: Color
    public var internalSpacing: CGFloat
    public var externalSpacing: CGFloat
    public var liquidGlassEnabled: Bool
    public var stretched: Bool
    
    private static func evaluateDefaultBackgroundColor(isLiquidGlassEnabled: Bool) -> Color {
        if isLiquidGlassAvailable && isLiquidGlassEnabled {
            return .clear
        }
        return Color.adaptive(light: "#0C0F1A", lightOpacity: 0.66, dark: "#FFFFFF", darkOpacity: 0.48)
    }

    public init(
        cornerRadius: CGFloat = 32,
        backgroundColor: Color? = nil,
        internalSpacing: CGFloat = 5,
        externalSpacing: CGFloat = 10,
        liquidGlassEnabled: Bool = false,
        stretched: Bool = false
    ) {
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = Self.evaluateDefaultBackgroundColor(isLiquidGlassEnabled: liquidGlassEnabled)
        }
        self.cornerRadius = cornerRadius
        self.internalSpacing = internalSpacing
        self.externalSpacing = externalSpacing
        self.liquidGlassEnabled = liquidGlassEnabled
        self.stretched = stretched
    }
}
