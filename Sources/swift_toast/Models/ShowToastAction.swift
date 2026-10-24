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
    @Entry var showToast = ShowToastAction<Any>(action: { _, _, _  in })
    //@Entry var dismissToast: VoidFunc = { }
}

struct ShowToastAction<TData: Hashable> {
    typealias Action = (ToastType<TData>, ToastPlacement, TimeInterval) -> Void
    let action: Action
    
    func callAsFunction(_ type: ToastType<TData>,
                        placement: ToastPlacement = .top,
                        dismissAfter: TimeInterval = DEFAULT_DISMISS_TIMEOUT) {
        action(type, placement, dismissAfter)
    }
}
