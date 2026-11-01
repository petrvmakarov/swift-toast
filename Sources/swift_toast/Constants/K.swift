//
//  K.swift
//  SwiftToast
//
//  Created by Petr Makarov on 27/10/2026.
//

import SwiftUI

package enum K {
    package static var isLiquidGlassAvailable: Bool {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0, *) {
            return true
        }
        return false
    }

    package enum Defaults {
        package static let dismissAfter: TimeInterval = 5.0
        package static let liquidGlassEnabled = true
        package static let backgroundRegular = Color(uiColor: .systemBackground) // Color.adaptive(light: "#5E6168", dark: "#222222")
        package static let backgroundLiquidGlass: Color = .clear
        package static let titleFont: Font = .footnote.bold()
        package static let titleColor: ColorWithLiquidGlass = .init(
            regular: .primary,
            liquidGlass: .primary
        )
        package static let messageFont: Font = .footnote
        package static let messageColor: ColorWithLiquidGlass = .init(
            regular: .primary,
            liquidGlass: .primary
        )
        package static let lightThemeToastShadow: Shadow = Shadow(color: .black.opacity(0.35), radius: 5)
        package static let darkThemeToastShadow: Shadow = Shadow(color: .white.opacity(0.15), radius: 5)
    }
    
    public enum IconSize {
        public static let m: CGSize = .init(width: 28, height: 28)
    }
}
