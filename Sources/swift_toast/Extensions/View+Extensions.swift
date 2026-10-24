//
//  View+Extensions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

extension View {
    public func withToast() -> some View {
        modifier(ToastModifier())
    }
}
