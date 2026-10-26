import SwiftUI
import swift_toast

public struct ContentView: View {
    @Environment(\.showToast) private var showToast
    
    public init() {}

    public var body: some View {
        Text("Hello toast!")
        Button {
            showToast(.info(title: "hello", message: "from toast"))
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
            showToast(.warning(title: "hello", message: "from toast"))
        } label: {
            Text("Warning")
        }
        Button {
            showToast(.error(title: "hello", message: "from toast"))
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
