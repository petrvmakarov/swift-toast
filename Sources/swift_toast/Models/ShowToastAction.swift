//
//  ShowToastAction.swift
//  SwiftToast
//
//  Created by Petr Makarov on 24/10/2026.
//

import Foundation
import SwiftUI

public struct ShowToastAction {
    typealias Action = (ToastType, ToastPlacement, TimeInterval) -> Void
    let action: Action

    @MainActor
    public func callAsFunction(
        _ type: ToastType,
        placement: ToastPlacement = .top,
        dismissAfter: TimeInterval? = nil
    ) {
        action(type, placement, dismissAfter ?? K.Defaults.dismissAfter)
    }
}
