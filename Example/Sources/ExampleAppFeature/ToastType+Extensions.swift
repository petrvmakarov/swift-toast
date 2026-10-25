//
//  ToastType+Extensions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//
import SwiftUI
import swift_toast

extension ToastType {
    @MainActor
    public static func showString(_ message: String) -> ToastType {
        .custom(
            message,
            ToastPresentationOptions(renderMessage: { m in Text(m) })
        )
    }
}
