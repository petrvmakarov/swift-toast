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
                    title: "hello",
                    message: "from toast",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .success:
                .success(
                    title: "hello",
                    message: "from toast",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .error:
                .error(
                    title: "hello",
                    message: "from toast",
                    options: .init(liquidGlassEnabled: liquidGlassEnabled)
                )
        case .warning:
                .warning(
                    title: "hello",
                    message: "from toast",
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
        PageLayout(
            title: "Predefined toasts",
            instructions: """
            Predefined toast types: .info, .success, .warning, .error
            Available placemnt: .top, .bottom
            """,
            code: code,
            codeMaxHeight: 320
        ) {
            
            
            HStack {
                Text("Placement")
                Spacer()
                Picker("Toast type", selection: $toastPlacement) {
                    ForEach(DemoToastPlacement.allCases) { type in
                        Text(type.title)
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
            }

            Stepper(
                "Dismiss after \(Int(dismissAfter)) seconds",
                value: $dismissAfter,
                in: 1...10,
                step: 1
            )
            
            Toggle("Enable liquid glass", isOn: $liquidGlassEnabled)

            Button {
                showToast(
                    toastTypeObject,
                    placement: toastPlacement == .top ? .top : .bottom,
                    dismissAfter: dismissAfter)
            } label: {
                Text("Show message")
            }.padding(.top)
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
    
    private static func getCode(
        toastType: String,
        placement: String,
        liquidGlass: Bool,
        dismissAfter: TimeInterval
    ) -> String { """
    Button {
     showToast(
        .\(toastType)(
            title: "hello",
            message: "from toast",
            options: .init(
                liquidGlassEnabled: \(liquidGlass ? "true" : "false")
            )
        ),
        placement: .\(placement),
        dismissAfter: \(Int(dismissAfter)))
    } label: {
      Text("Show message")
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
