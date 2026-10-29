//
//  ToastType+Extensions.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//
import SwiftUI

extension ToastType {
    public struct UndoOptions: Hashable {
        public static func == (lhs: UndoOptions, rhs: UndoOptions) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id: UUID = UUID()
        var duration: TimeInterval? = nil
        var liquidGlassEnabled: Bool = K.Defaults.liquidGlassEnabled
        var onButtonTap: () -> Void
        
        public init(duration: TimeInterval? = nil, liquidGlassEnabled: Bool, onButtonTap: @escaping () -> Void) {
            self.duration = duration
            self.liquidGlassEnabled = liquidGlassEnabled
            self.onButtonTap = onButtonTap
        }
    }
    
    @MainActor
    public static func undo(_ title: String, message: String, options: UndoOptions) -> ToastType {
        let titleAndMessageOptions = ToastOptions.default
        let duration = options.duration ?? K.Defaults.dismissAfter
        let circleWidth: CGFloat = options.liquidGlassEnabled ? 0.9 : 3.5
        return .custom(
            options,
            ToastPresentationOptions(
                messageViewOptions: ToastContainerViewOptions(
                    backgroundColor: K.isLiquidGlassAvailable && options.liquidGlassEnabled ? K.Defaults.backgroundLiquidGlass : K.Defaults.backgroundRegular,
                    internalSpacing: 15,
                    externalSpacing: 15,
                    liquidGlassEnabled: options.liquidGlassEnabled,
                    
                ),
                renderMessage: { _ in
                    TitleAndMessageView(
                        title: title,
                        message: message,
                        messageTitleSpacing: 0,
                        titleColor: titleAndMessageOptions.titleColor.getColor(for: options.liquidGlassEnabled),
                        messageColor: titleAndMessageOptions.messageColor.getColor(for: options.liquidGlassEnabled),
                        titleFont: titleAndMessageOptions.titleFont,
                        messageFont: titleAndMessageOptions.messageFont,
                    )
                },
                renderLeftAccessory: { _ in
                    CountdownView(value: duration, color: .blue, gapColor: .white, size: 44, lineWidth: circleWidth, gapWidth: 2, fontSize: 14, liquidGlassEnabled: options.liquidGlassEnabled,)
                        .frame(width: K.IconSize.m.width, height: K.IconSize.m.height)
                },
                renderRightAccessory: { _ in ImageButton(
                    .systemName("arrow.uturn.backward"),
                    withOptions: .init(foregroundColor: .blue)
                ) {
                    options.onButtonTap()
                } }
            ))
        
    }
}
