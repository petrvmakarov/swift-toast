import SwiftToast
import SwiftUI

public struct ContentView: View {
    @State private var isSplashPresented = true

#if DEBUG
    private let isReadmeDemo = ProcessInfo.processInfo.arguments.contains("--readme-demo")
#else
    private let isReadmeDemo = false
#endif

    public init() {}

    @ViewBuilder
    public var body: some View {
        if isReadmeDemo {
            ReadmeDemoScreen()
                .withToast()
        } else {
            ZStack {
                DemoPagesScreen()

                if isSplashPresented {
                    splashScreen
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .withToast()
        }
    }

    private var splashScreen: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ToasterArtwork {
                withAnimation(.easeOut(duration: 0.35)) {
                    isSplashPresented = false
                }
            }
        }
        .accessibilityAddTraits(.isImage)
    }
}

#Preview {
    ContentView()
        .accentColor(.blue)
}
