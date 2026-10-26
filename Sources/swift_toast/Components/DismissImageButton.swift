//
//  DismissImageButton.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

package struct DismissImageButton: View {
    @Environment(\.dismissToast) private var dismissToast
    
    private var source: ImageSource
    private var options: ImageButtonOptions
    
    init(_ source: ImageSource, withOptions options: ImageButtonOptions) {
        self.source = source
        self.options = options
    }

    package var body: some View {
        ImageButton(
            source,
            withOptions: options
        ) {
            dismissToast()
        }
    }
}
