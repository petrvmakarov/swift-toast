import SwiftUI
import swift_toast

public struct ContentView: View {
    @Environment(\.showToast) private var showToast
    
    public init() {}

    public var body: some View {
        Text("Hello toast!")
        Button {
            showToast(ToastType<String>.info(TitleAndMessage(title: "hello", message: "from toast")))
        } label: {
            Text("Press me")
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ContentView()
        Spacer()
    }
        .withToast()
}
