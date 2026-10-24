//
//  ToastType.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//


import SwiftUI

enum ToastType<TData: Hashable> {
    case info(TitleAndMessage)
    case success(TitleAndMessage)
    case warning(TitleAndMessage)
    case error(TitleAndMessage)

    case custom(TData, ToastPresentationOptions<TData>)
}


extension ToastType<String> {
    static func showString(_ message: String) -> ToastType<String> {
        .custom(message, ToastPresentationOptions(
            renderMessage: { s in Text(s) }
        ))
    }
//    static var justString: ToastType {
//        .custom("b", ToastPresentationOptions(
//            renderMessage: (
//        ))
//    }
}
