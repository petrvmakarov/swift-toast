//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

struct ToatType {
    @MainActor static let success: ToatType = ToatType()
    @MainActor static let info: ToatType = ToatType()
    @MainActor static let warning: ToatType = ToatType()
    @MainActor static let error: ToatType = ToatType()
}


extension ToatType {
    @MainActor static let custom: ToatType = ToatType()
}
