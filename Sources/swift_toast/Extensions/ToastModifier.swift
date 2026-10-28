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
    
    @State private var toastId: UUID = UUID()
    
    func onDismiss() {
        withAnimation(.easeInOut) {
            self.type = nil
        }
    }
    
    func onShow(
        _ type: ToastType,
        placement: ToastPlacement,
        dismissAfter: TimeInterval
    ) {
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
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: placement == .top ? .top: .bottom) {
                Group {
                    if let type {
                        type.renderView()
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
