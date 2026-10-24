//
//  ToastMessageViewOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

public struct ToastMessageViewOptions {
    public static var `default`: ToastMessageViewOptions { ToastMessageViewOptions() }

    public var cornerRadius: CGFloat
    public var backgroundColor: Color
    public var accessoryViewSpacing: CGFloat
    public var liquidGlassEnabled: Bool

    public init(
        cornerRadius: CGFloat = 32,
        backgroundColor: Color = .gray,
        accessoryViewSpacing: CGFloat = 12,
        liquidGlassEnabled: Bool = false
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.accessoryViewSpacing = accessoryViewSpacing
        self.liquidGlassEnabled = liquidGlassEnabled
    }
}
