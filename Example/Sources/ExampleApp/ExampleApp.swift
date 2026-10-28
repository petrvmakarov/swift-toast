import SwiftUI

#if SWIFT_PACKAGE
import ExampleAppFeature
#endif

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
