//
//  ImageButton.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

public struct ImageButtonOptions {
    var forgroundColor: Color
    var backgroundColor: Color? = nil
    var hideBackground = false
    
    var actualBackgroundColor: Color {
        guard let backgroundColor = backgroundColor else {
            return forgroundColor.opacity(0.25)
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
                    .foregroundStyle(options.forgroundColor)
            }
//            .frame(maxHeight: 44)
//            .frame(width: 44)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ImageButton(.systemName("xmark"), withOptions: .init(forgroundColor: .red)) {
            print("xmark tapped")
        }
        
        ImageButton(.systemName("xmark"), withOptions: .init(forgroundColor: .blue, backgroundColor: nil)) {
            print("xmark tapped")
        }
        
        ImageButton(.systemName("xmark"), withOptions: .init(forgroundColor: .yellow, backgroundColor: nil)) {
            print("xmark tapped")
        }
        Spacer()
    }
    
}
