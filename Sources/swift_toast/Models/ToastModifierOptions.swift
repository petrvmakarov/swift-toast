//
//  ToastModifierOptions.swift
//  SwiftToast
//

public struct ToastModifierOptions {
    public var swipeToDismissEnabled: Bool

    public init(
        swipeToDismissEnabled: Bool = true
    ) {
        self.swipeToDismissEnabled = swipeToDismissEnabled
    }
}
