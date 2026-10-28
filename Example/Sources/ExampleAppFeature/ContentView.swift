import SwiftUI
import swift_toast

public struct ContentView: View {
    @State private var swipeToDismissEnabled = true

    public init() {}

    public var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 0)
            }
            Spacer()
            Toggle("Swipe to dismiss", isOn: $swipeToDismissEnabled)
                .padding(.horizontal)

            ToastExamplesView()
            HStack {
                Spacer(minLength: 0)
            }
            Spacer()
        }
        .withToast(
            .init(swipeToDismissEnabled: swipeToDismissEnabled)
        )
    }
}

private struct ToastExamplesView: View {
    @Environment(\.showToast) private var showToast
    @Environment(\.dismissToast) private var dismissToast
    @State private var counter = 0
    @State private var isLiquidGlassEnabled = K.isLiquidGlassAvailable
    @State private var toastPlacement: ToastPlacement = .top
    
    var body: some View {
        Text("Hello toast!")
        Text("Warning toast tapped \(counter) time(s)")
        VStack {
            Toggle("Enable liquid glass", isOn: $isLiquidGlassEnabled)
            HStack {
                Text("Placement")
                Spacer()
                Picker("Toast placement", selection: $toastPlacement) {
                    Text("Top").tag(ToastPlacement.top)
                    Text("Bottom").tag(ToastPlacement.bottom)
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
            }
        }.padding(.horizontal)
        
        Button {
            showToast(
                .info(
                    title: "hello",
                    message: "from toast",
                    options: ToastConfiguration(liquidGlassEnabled: isLiquidGlassEnabled)
                ), placement: toastPlacement)
            //showToast(.showString("custom text"), placement: .bottom, dismissAfter: 10)
        } label: {
            Text("Info")
        }
        Button {
            showToast(
                .success(title: "hello",
                         message: "from toast",
                         options: ToastConfiguration(liquidGlassEnabled: isLiquidGlassEnabled)),
                placement: toastPlacement
            )
        } label: {
            Text("Success")
        }
        Button {
            showToast(
                .warning(title: "hello", message: "from toast",
                         options: ToastConfiguration(
                            liquidGlassEnabled: isLiquidGlassEnabled,
                            onTap: {
                                dismissToast()
                                counter += 1
                            })),
                placement: toastPlacement
            )
        } label: {
            Text("Warning")
        }
        
        Button {
            //xmark.circle.fill
            showToast(
                .error(title: "hello",
                       message: "from toast",
                       options: ToastConfiguration(liquidGlassEnabled: isLiquidGlassEnabled)
                      ),
                placement: toastPlacement
            )
        } label: {
            Text("Error")
        }
        
        Button {
            //xmark.circle.fill
            showToast(
                .error(title: "hello",
                       message: "from toast",
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
                      ), placement: toastPlacement
            )
        } label: {
            Text("Error customized")
        }
    }
}

#Preview {

        ContentView()
        
    
}
