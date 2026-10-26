//
//  ImageAccessoryView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//

import SwiftUI

public struct ImageAccessory: View {
    public enum Source {
        case systemName(String)
        case asset(String)
        case uiImage(UIImage)
        case cgImage(CGImage)
        case image(Image)

        var image: Image {
            switch self {
            case .systemName(let name):
                Image(systemName: name)

            case .asset(let name):
                Image(name)

            case .uiImage(let image):
                Image(uiImage: image)

            case .cgImage(let image):
                Image(
                    decorative: image,
                    scale: 1.0
                )

            case .image(let image):
                image
            }
        }
    }
    
    private var source: Source
    
    public init(_ source: Source) {
        self.source = source
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            source.image
                .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            .foregroundStyle(.red)
        }
        //.frame(maxHeight: 44)
        //.frame(width: 44)
        
        //.background(.blue)
        
        //.padding(0)
    }
}

#Preview {
    ImageAccessory(.systemName("checkmark.circle.fill"))
}
