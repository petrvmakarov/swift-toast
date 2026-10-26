//
//  SystemHelper.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

struct SystemHelper {
    static func isLiquidGlassAvailable() -> Bool {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *) {
            return true
        }
        return false
    }
}
