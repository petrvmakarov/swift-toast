//
//  ImageSource.swift
//  SwiftToast
//
//  Created by Petr Makarov on 26/10/2026.
//


public enum ImageSource {
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