import SwiftUI
import swift_toast

public struct ContentView: View {
    @Environment(\.showToast) private var showToast
    @Environment(\.dismissToast) private var dismissToast
    @State private var counter = 0
    @State private var isLiquidGlassEnabled = isLiquidGlassAvailable()
    
    public init() {}
    
    static func isLiquidGlassAvailable() -> Bool {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0,  *) {
            return true
        }
        return false
    }
    
    public var body: some View {
        Text("Hello toast!")
        Text("Warning toast tapped \(counter) time(s)")
        Toggle("Enable liquid glass", isOn: $isLiquidGlassEnabled)
            .padding(.horizontal)
        
        Button {
            showToast(
                .info(
                    title: "hello",
                    message: "from toast",
                    options: UserToastOptions(isLiquidGlassEnabled: isLiquidGlassEnabled)
                ))
            //showToast(.showString("custom text"), placement: .bottom, dismissAfter: 10)
        } label: {
            Text("Info")
        }
        Button {
            showToast(.success(title: "hello",
                               message: "from toast",
                               options: UserToastOptions(isLiquidGlassEnabled: isLiquidGlassEnabled)
                              ))
        } label: {
            Text("Success")
        }
        Button {
            showToast(
                .warning(title: "hello", message: "from toast",
                         options: UserToastOptions(
                            isLiquidGlassEnabled: isLiquidGlassEnabled,
                            onTap: {
                                dismissToast()
                                counter += 1
                            }))
            )
        } label: {
            Text("Warning")
        }
        Button {
            //xmark.circle.fill
            showToast(
                .error(title: "hello",
                       message: "from toast",
                       options: UserToastOptions(isLiquidGlassEnabled: isLiquidGlassEnabled)
                      )
            )
        } label: {
            Text("Error")
        }
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer(minLength: 0)
        }
        ContentView()
        HStack {
            Spacer(minLength: 0)
        }
        Spacer()
    }
    
    .withToast()
}
