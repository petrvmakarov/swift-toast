//
//  ImageAccessoryView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

public struct ImageAccessoryOptions {
    public var foregroundColor: Color

    public init(
        foregroundColor: Color = .accentColor
    ) {
        self.foregroundColor = foregroundColor
    }
}

public struct ImageAccessory: View {
    private var source: ImageSource
    private var options: ImageAccessoryOptions
    
    public init(
        _ source: ImageSource,
        withOptions options: ImageAccessoryOptions? = nil) {
        self.source = source
        self.options = options ?? ImageAccessoryOptions()
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            source.image
                .resizable()
                    .scaledToFit()
                    .frame(width: K.IconSize.m.width, height: K.IconSize.m.height)
                    .foregroundStyle(options.foregroundColor)
        }
    }
}

#Preview {
    ImageAccessory(.systemName("checkmark.circle.fill"))
}
