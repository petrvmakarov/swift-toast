//
//  ToastMessageViewOptions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import SwiftUI

private let defaultCornerRadius: CGFloat = 32
private let defaultBackgroundColor: Color = .gray
private let defaultAccessoryViewSpacing: CGFloat = 12

struct ToastMessageViewOptions {
    static let `default` = ToastMessageViewOptions()
    var cornerRadius: CGFloat = defaultCornerRadius
    var backgroundColor: Color = defaultBackgroundColor
    var accessoryViewSpacing: CGFloat = defaultAccessoryViewSpacing
    var liquidGlassEnabled: Bool = false
}
