import SwiftUI
import swift_toast

public struct ContentView: View {
    @Environment(\.showToast) private var showToast
    @Environment(\.dismissToast) private var dismissToast
    @State private var counter = 0
    
    public init() {}

    public var body: some View {
        Text("Hello toast!")
        Text("Toast tapped \(counter) time(s)")
        Button {
            showToast(.info(title: "hello", message: "from toast", options: UserToastOptions(iconSystemName: "info.circle.fill", isLiquidGlassEnabled: true)))
            //showToast(.showString("custom text"), placement: .bottom, dismissAfter: 10)
        } label: {
            Text("Info")
        }
        Button {
            showToast(.success(title: "hello", message: "from toast"))
        } label: {
            Text("Success")
        }
        Button {
            showToast(
                .warning(title: "hello", message: "from toast",
                         options: UserToastOptions(onTap: {
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
                .error(title: "hello", message: "from toast",
                options: UserToastOptions(iconSystemName: "xmark.circle.fill")
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
