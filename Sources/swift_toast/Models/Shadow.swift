//
//  Shadow.swift
//  SwiftToast
//
//  Created by Petr Makarov on 31/10/2026.
//

import SwiftUI

package struct Shadow {
    var color: Color
    var radius: CGFloat

    static func adaptive(
        light: Shadow,
        dark: Shadow,
        for colorScheme: ColorScheme
    ) -> Shadow {
        switch colorScheme {
        case .dark:
            dark
        default:
            light
        }
    }
}
