//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftToast
import SwiftUI

struct Page04Undo: View {
    @State private var liquidGlassEnabled: Bool = true
    @State private var toastType: DemoToastType = .info
    @State private var toastPlacement: DemoToastPlacement = .top
    @State private var dismissAfter: TimeInterval = 10
    @State private var code: String = ""
    @State private var isUndoAlertPresented = false
    
    @Environment(\.showToast) private var showToast
    @Environment(\.dismissToast) private var dismissToast
    @Environment(\.walkthroughShowToastTrigger) private var walkthroughShowToastTrigger
    
    var toastTypeObject: ToastType {
        .undo("Item was deleted",
              message: "Tap to undo",
              options: .init(
                duration: dismissAfter,
                tint: .cyan,
                liquidGlassEnabled: liquidGlassEnabled,
                onButtonTap: {
                    dismissToast()
                    isUndoAlertPresented = true
                })
             )
    }
    
    private func refreshCode() {
        code = Self.getCode(
            placement: toastPlacement.rawValue,
            liquidGlass: liquidGlassEnabled,
            dismissAfter: dismissAfter)
    }
    
    var body: some View {
        PinnedActionPage {
            PageLayout(
                title: "Undo toast",
                code: code,
                codeMaxHeight: 480
            ) {
                HStack {
                    Text("Placement")
                    Spacer()
                    Picker("Placement", selection: $toastPlacement) {
                        ForEach(DemoToastPlacement.allCases) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Toggle("Enable Liquid Glass", isOn: $liquidGlassEnabled)
            }
        } action: {
            Button(action: presentToast) {
                Label("Show toast", systemImage: "bell.badge.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .alert("Item restored", isPresented: $isUndoAlertPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The deleted item was restored.")
        }
        .onAppear {
            refreshCode()
        }
        .onChange(of: toastType) {
            refreshCode()
        }
        .onChange(of: toastPlacement) {
            refreshCode()
        }
        .onChange(of: liquidGlassEnabled) {
            refreshCode()
        }
        .onChange(of: dismissAfter) {
            refreshCode()
        }
        .onChange(of: walkthroughShowToastTrigger) { _, trigger in
            guard trigger > 0 else { return }
            presentToast()
        }
    }

    private func presentToast() {
        showToast(
            toastTypeObject,
            placement: toastPlacement == .top ? .top : .bottom,
            dismissAfter: dismissAfter)
    }
    
    private static func getCode(
        placement: String,
        liquidGlass: Bool,
        dismissAfter: TimeInterval
    ) -> String { """
    @State private var isUndoAlertPresented = false

    Button {
     showToast(
        .undo("Item was deleted",
              message: "Tap to undo",
              options: .init(
                duration: dismissAfter,
                tint: .cyan,
                liquidGlassEnabled: \(liquidGlass ? "true" : "false"),
                onButtonTap: {
                    dismissToast()
                    isUndoAlertPresented = true
                })
             ),
        placement: .\(placement),
        dismissAfter: \(Int(dismissAfter)))
    } label: {
      Text("Show toast")
    }
    .alert("Item restored", isPresented: $isUndoAlertPresented) {
        Button("OK", role: .cancel) {}
    } message: {
        Text("The deleted item was restored.")
    }
    """
    }
}

#Preview {
    VStack {
        Page04Undo()
        Spacer()
    }
        .withToast()
}
