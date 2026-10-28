//
//  ToastModifier.swift
//  SwiftToast
//
//  Created by Petr Makarov on 25/10/2026.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @State private var type: ToastType?
    @State private var placement: ToastPlacement = .top
    @State private var disappearAfter: TimeInterval = 2.0
    @State private var dismissTask: DispatchWorkItem?
    @State private var dragOffset: CGFloat = 0
    
    @State private var toastId: UUID = UUID()
    
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
        self.disappearAfter = dismissAfter
        
        // cancel previous dismissal task if any
        dismissTask?.cancel()
        
        // schedule a new dismisal
        let task = DispatchWorkItem {
            self.onDismiss()
        }
        
        self.dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + disappearAfter + 1, execute: task)
    }

    private var swipeToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                switch placement {
                case .top:
                    dragOffset = min(value.translation.height, 0)
                case .bottom:
                    dragOffset = max(value.translation.height, 0)
                }
            }
            .onEnded { value in
                let projectedDistance: CGFloat

                switch placement {
                case .top:
                    projectedDistance = -value.predictedEndTranslation.height
                case .bottom:
                    projectedDistance = value.predictedEndTranslation.height
                }

                if projectedDistance > 80 {
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
