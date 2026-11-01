//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftToast
import SwiftUI

enum DemoToastType: String, CaseIterable, Identifiable {
    case info
    case success
    case error
    case warning

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

enum DemoToastPlacement: String, CaseIterable, Identifiable {
    case top
    case bottom

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

struct Page02: View {
    @State private var liquidGlassEnabled: Bool = false
    @State private var toastType: DemoToastType = .info
    @State private var toastPlacement: DemoToastPlacement = .top
    @State private var dismissAfter: TimeInterval = 5
    @State private var code: String = ""
    
    @Environment(\.showToast) private var showToast
    
    var toastTypeObject: ToastType {
        switch toastType {
        case .info:
                .info(
                    title: "Hello",
                    message: "This is a toast message.",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .success:
                .success(
                    title: "Hello",
                    message: "This is a toast message.",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .error:
                .error(
                    title: "Hello",
                    message: "This is a toast message.",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .warning:
                .warning(
                    title: "Hello",
                    message: "This is a toast message.",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        }
        
    }
    
    private func refreshCode() {
        code = Self.getCode(
            toastType: toastType.rawValue,
            placement: toastPlacement.rawValue,
            liquidGlass: liquidGlassEnabled,
            dismissAfter: dismissAfter)
    }
    
    var body: some View {
        PinnedActionPage {
            PageLayout(
                title: "Predefined toasts",
                instructions: """
                Choose from four predefined toast types: .info, .success, .warning, and .error.
                Available placements: .top and .bottom.
                """,
                code: code,
                codeMaxHeight: 320
            ) {
                HStack {
                    Text("Toast type")
                    Spacer()
                    Picker("Toast type", selection: $toastType) {
                        ForEach(DemoToastType.allCases) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

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

                Stepper(
                    dismissAfterLabel,
                    value: $dismissAfter,
                    in: 1...10,
                    step: 1
                )

                Toggle("Enable Liquid Glass", isOn: $liquidGlassEnabled)
            }
        } action: {
            Button {
                showToast(
                    toastTypeObject,
                    placement: toastPlacement == .top ? .top : .bottom,
                    dismissAfter: dismissAfter)
            } label: {
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
    }

    private var dismissAfterLabel: String {
        let seconds = Int(dismissAfter)
        let unit = seconds == 1 ? "second" : "seconds"
        return "Dismiss after \(seconds) \(unit)"
    }
    
    private static func getCode(
        toastType: String,
        placement: String,
        liquidGlass: Bool,
        dismissAfter: TimeInterval
    ) -> String { """
    Button {
     showToast(
        .\(toastType)(
            title: "Hello",
            message: "This is a toast message.",
            options: .init(
                liquidGlassEnabled: \(liquidGlass ? "true" : "false")
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
        Page02()
        Spacer()
    }
        .withToast()
}
