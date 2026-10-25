import SwiftUI
import swift_toast

public struct ContentView: View {
    @Environment(\.showToast) private var showToast
    
    public init() {}

    public var body: some View {
        Text("Hello toast!")
        Button {
           // showToast(.info(title: "hello", message: "from toast"))
            showToast(.showString("custom text"), placement: .bottom, dismissAfter: 10)
        } label: {
            Text("Press me")
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
