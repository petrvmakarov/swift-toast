//
//  ShowToastAction.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import Foundation
import SwiftUI

fileprivate let DEFAULT_DISMISS_TIMEOUT: TimeInterval = 2.0

extension EnvironmentValues {
    @Entry var showToast = ShowToastAction(action: { _, _, _ in })
}

struct AnyToastType {
    private let storage: Any

    init<TData: Hashable>(_ type: ToastType<TData>) {
        storage = type
    }

    func value<TData: Hashable>(
        as dataType: TData.Type = TData.self
    ) -> ToastType<TData>? {
        storage as? ToastType<TData>
    }
}

struct ShowToastAction {
    typealias Action = (AnyToastType, ToastPlacement, TimeInterval) -> Void
    let action: Action

    func callAsFunction<TData: Hashable>(
        _ type: ToastType<TData>,
        placement: ToastPlacement = .top,
        dismissAfter: TimeInterval = DEFAULT_DISMISS_TIMEOUT
    ) {
        action(AnyToastType(type), placement, dismissAfter)
    }
}
