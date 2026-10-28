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

    enum Defaults {
        static let liquidGlassEnabled = true
        static let backgroundRegular = Color.adaptive(light: "#FEFEFE", dark: "#222222")
        static let backgroundLiquidGlass: Color = .clear
    }
}
