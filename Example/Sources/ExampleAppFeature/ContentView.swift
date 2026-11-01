import SwiftToast
import SwiftUI

public struct ContentView: View {
    @State private var isSplashPresented = true

    public init() {}

    public var body: some View {
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
