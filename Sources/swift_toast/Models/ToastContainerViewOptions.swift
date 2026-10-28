//
//  ToastMessageViewOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

public struct ToastContainerViewOptions {
    public static var `default`: ToastContainerViewOptions { ToastContainerViewOptions(
        cornerRadius: 32,
        backgroundColor: .clear,
        internalSpacing: 5,
        externalSpacing: 10,
        liquidGlassEnabled: false,
        stretched: false
    ) }

    public var cornerRadius: CGFloat
    public var backgroundColor: Color
    public var internalSpacing: CGFloat
    public var externalSpacing: CGFloat
    public var liquidGlassEnabled: Bool
    public var stretched: Bool
    
    
    package init(
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        internalSpacing: CGFloat? = nil,
        externalSpacing: CGFloat? = nil,
        liquidGlassEnabled: Bool? = nil,
        stretched: Bool? = nil
    ) {
        self.backgroundColor = backgroundColor ?? Self.default.backgroundColor
        self.cornerRadius = cornerRadius ?? Self.default.cornerRadius
        self.internalSpacing = internalSpacing ?? Self.default.internalSpacing
        self.externalSpacing = externalSpacing ?? Self.default.externalSpacing
        self.liquidGlassEnabled = liquidGlassEnabled ?? Self.default.liquidGlassEnabled
        self.stretched = stretched ?? Self.default.stretched
    }

}
