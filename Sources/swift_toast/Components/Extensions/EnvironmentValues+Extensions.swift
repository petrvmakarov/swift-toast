//
//  EnvironmentValues+Extensions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

extension EnvironmentValues {
    @Entry public var showToast = ShowToastAction(action: { _, _, _ in })
    @Entry var dismissToast: () -> Void = { }
}
