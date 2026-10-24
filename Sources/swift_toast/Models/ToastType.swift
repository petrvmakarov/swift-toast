//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

struct ToatType {
    @MainActor static let success: ToatType = ToatType(messageViewOptions: ToastMessageViewOptions.default)
    @MainActor static let info: ToatType = ToatType(messageViewOptions: ToastMessageViewOptions.default)
    @MainActor static let warning: ToatType = ToatType(messageViewOptions: ToastMessageViewOptions.default)
    @MainActor static let error: ToatType = ToatType(messageViewOptions: ToastMessageViewOptions.default)
    
    let messageViewOptions: ToastMessageViewOptions
}


extension ToatType {
    @MainActor static let custom: ToatType = ToatType(messageViewOptions: ToastMessageViewOptions.default)
}
