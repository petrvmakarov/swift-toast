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
    public var internalSpacing: CGFloat
    public var externalSpacing: CGFloat
    public var liquidGlassEnabled: Bool
    public var stretched: Bool

    public init(
        cornerRadius: CGFloat = 32,
        backgroundColor: Color = .clear,// Color(UIColor.systemBackground),
        internalSpacing: CGFloat = 5,
        externalSpacing: CGFloat = 10,
        liquidGlassEnabled: Bool = false,
        stretched: Bool = false
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.internalSpacing = internalSpacing
        self.externalSpacing = externalSpacing
        self.liquidGlassEnabled = liquidGlassEnabled
        self.stretched = stretched
    }
}
