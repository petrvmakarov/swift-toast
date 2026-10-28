//
//  ImageButton.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

public struct ImageButtonOptions {
    public var foregroundColor: Color
    public var backgroundColor: Color?
    public var hideBackground: Bool

    public init(
        foregroundColor: Color,
        backgroundColor: Color? = nil,
        hideBackground: Bool = false
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.hideBackground = hideBackground
    }
    
    var actualBackgroundColor: Color {
        guard let backgroundColor = backgroundColor else {
            return foregroundColor.opacity(0.25)
        }
        return backgroundColor
    }
}

public struct ImageButton: View {
    private var source: ImageSource
    private var options: ImageButtonOptions
    private var onTap: () -> Void
    
    public init(_ source: ImageSource, withOptions options: ImageButtonOptions, onTap: @escaping () -> Void) {
        self.source = source
        self.options = options
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                if !options.hideBackground {
                    Circle()
                        .fill(options.actualBackgroundColor)
                        .frame(width: 28, height: 28)
                }
                source.image
                    .foregroundStyle(options.foregroundColor)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ImageButton(.systemName("xmark"), withOptions: .init(foregroundColor: .red)) {
            print("xmark tapped")
        }
        
        ImageButton(.systemName("xmark"), withOptions: .init(foregroundColor: .blue, backgroundColor: nil)) {
            print("xmark tapped")
        }
        
        ImageButton(.systemName("xmark"), withOptions: .init(foregroundColor: .yellow, backgroundColor: nil)) {
            print("xmark tapped")
        }
        Spacer()
    }
    
}
