//
//  Color+Extensions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 17/03/2025.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255.0
        g = Double((int >> 8) & 0xFF) / 255.0
        b = Double(int & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }

    static func adaptive(light: String, lightOpacity: CGFloat = 1.0, dark: String, darkOpacity: CGFloat = 1.0) -> Color {
#if canImport(UIKit)
        Color(
            UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(hex: dark).withAlphaComponent(darkOpacity)
                default:
                    return UIColor(hex: light).withAlphaComponent(lightOpacity)
                }
            }
        )
#elseif canImport(AppKit)
        Color(
            nsColor: NSColor(name: nil) { appearance in
                switch appearance.bestMatch(from: [.darkAqua, .aqua]) {
                case .darkAqua:
                    return NSColor(hex: dark).withAlphaComponent(darkOpacity)
                default:
                    return NSColor(hex: light).withAlphaComponent(lightOpacity)
                }
            }
        )
#else
        Color(hex: dark).opacity(darkOpacity)
#endif
    }

    static func adaptive(lightOrDefault: Color, dark: Color? = nil) -> Color {
#if canImport(UIKit)
        Color(
            UIColor { traitCollection in
                let color = switch traitCollection.userInterfaceStyle {
                case .dark:
                    dark ?? lightOrDefault
                default:
                    lightOrDefault
                }

                return UIColor(color)
            }
        )
#elseif canImport(AppKit)
        Color(
            nsColor: NSColor(name: nil) { appearance in
                let color = switch appearance.bestMatch(from: [.darkAqua, .aqua]) {
                case .darkAqua:
                    dark ?? lightOrDefault
                default:
                    lightOrDefault
                }

                return NSColor(color)
            }
        )
#else
        dark ?? lightOrDefault
#endif
    }
}

#if canImport(UIKit)
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = CGFloat((int >> 16) & 0xFF) / 255.0
        let g = CGFloat((int >> 8) & 0xFF) / 255.0
        let b = CGFloat(int & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
#elseif canImport(AppKit)
extension NSColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = CGFloat((int >> 16) & 0xFF) / 255.0
        let g = CGFloat((int >> 8) & 0xFF) / 255.0
        let b = CGFloat(int & 0xFF) / 255.0

        self.init(srgbRed: r, green: g, blue: b, alpha: 1.0)
    }
}
#endif
