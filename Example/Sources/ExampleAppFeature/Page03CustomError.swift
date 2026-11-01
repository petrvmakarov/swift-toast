//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftToast
import SwiftUI

struct Page03CustomError: View {
    @State private var liquidGlassEnabled: Bool = false
    @State private var toastType: DemoToastType = .info
    @State private var toastPlacement: DemoToastPlacement = .top
    @State private var dismissAfter: TimeInterval = 5
    @State private var code: String = ""
    
    @Environment(\.showToast) private var showToast
    @Environment(\.walkthroughShowToastTrigger) private var walkthroughShowToastTrigger
    
    var toastTypeObject: ToastType {
        .error(title: "Hello",
               message: "This is a toast message.",
               options: ToastConfiguration(
                iconColor: .white,
                buttonTint: .white,
                titleFont: .headline,
                background: .red,
                liquidGlassEnabled: false,
                container: .init(
                    cornerRadius: 5,
                    internalSpacing: 15,
                    externalSpacing: 15,
                    stretched: true,
                    ignoreSafeArea: .all
                )
               )
              )
        
    }
    
    private func refreshCode() {
        code = Self.getCode(
            placement: toastPlacement.rawValue,
            dismissAfter: dismissAfter)
    }
    
    var body: some View {
        PinnedActionPage {
            PageLayout(
                title: "Custom error toast",
                code: code,
                codeMaxHeight: 420
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
            }
        } action: {
            Button(action: presentToast) {
                Label("Show toast", systemImage: "bell.badge.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
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
        dismissAfter: TimeInterval
    ) -> String { """
    Button {
     showToast(
        .error(title: "Hello",
               message: "This is a toast message.",
               options: .init(
                iconColor: .white,
                buttonTint: .white,
                titleFont: .headline,
                background: .red,
                liquidGlassEnabled: false,
                container: .init(
                    cornerRadius: 5,
                    internalSpacing: 15,
                    externalSpacing: 15,
                    stretched: true,
                    ignoreSafeArea: .all
                )
            )
        ),
        placement: .\(placement),
        dismissAfter: \(Int(dismissAfter)))
    } label: {
      Text("Show toast")
    }
    """
    }
}

#Preview {
    VStack {
        Page03CustomError()
        Spacer()
    }
        .withToast()
}
