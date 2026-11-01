import SwiftToast
import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        DemoPagesScreen()
            .withToast()
    }
}

#Preview {
    ContentView()
        .accentColor(.blue)
}
