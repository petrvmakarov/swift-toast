//
//  ToastModifier.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

enum ToastSwipeToDismissBehavior {
    static let dismissalThreshold: CGFloat = 80

    static func offset(
        for translation: CGFloat,
        placement: ToastPlacement
    ) -> CGFloat {
        switch placement {
        case .top:
            min(translation, 0)
        case .bottom:
            max(translation, 0)
        }
    }

    static func projectedDistance(
        for translation: CGFloat,
        placement: ToastPlacement
    ) -> CGFloat {
        switch placement {
        case .top:
            -translation
        case .bottom:
            translation
        }
    }

    static func shouldDismiss(
        predictedTranslation: CGFloat,
        placement: ToastPlacement,
        isEnabled: Bool
    ) -> Bool {
        isEnabled && projectedDistance(
            for: predictedTranslation,
            placement: placement
        ) > dismissalThreshold
    }
}

public struct ToastModifier: ViewModifier {
    private let options: ToastModifierOptions

    @State private var type: ToastType?
    @State private var placement: ToastPlacement = .top
    @State private var dismissTask: DispatchWorkItem?
    @State private var dragOffset: CGFloat = 0
    
    @State private var toastId: UUID = UUID()

    public init(
        options: ToastModifierOptions = .init()
    ) {
        self.options = options
    }
    
    func onDismiss() {
        dismissTask?.cancel()
        dismissTask = nil

        withAnimation(.easeInOut) {
            self.type = nil
        }

        dragOffset = 0
    }
    
    func onShow(
        _ type: ToastType,
        placement: ToastPlacement,
        dismissAfter: TimeInterval
    ) {
        dragOffset = 0

        withAnimation(.easeInOut) {
            self.type = type
            self.placement = placement
        }
        // cancel previous dismissal task if any
        dismissTask?.cancel()
        
        // schedule a new dismisal
        let task = DispatchWorkItem {
            self.onDismiss()
        }
        
        self.dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter, execute: task)
    }

    private var swipeToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                dragOffset = ToastSwipeToDismissBehavior.offset(
                    for: value.translation.height,
                    placement: placement
                )
            }
            .onEnded { value in
                if ToastSwipeToDismissBehavior.shouldDismiss(
                    predictedTranslation: value.predictedEndTranslation.height,
                    placement: placement,
                    isEnabled: options.swipeToDismissEnabled
                ) {
                    onDismiss()
                } else {
                    withAnimation(.spring(duration: 0.25)) {
                        dragOffset = 0
                    }
                }
            }
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: placement == .top ? .top: .bottom) {
                Group {
                    if let type {
                        type.renderView()
                            .offset(y: dragOffset)
                            .gesture(swipeToDismissGesture)
                    }
                }                
                .transition(
                    .move(edge: placement == .top ? .top: .bottom)
                    .combined(with: .opacity)
                )
                .id(type?.id)
            }
            .environment(\.dismissToast, onDismiss)
            .environment(\.showToast, ShowToastAction(action: onShow))
    }
}
