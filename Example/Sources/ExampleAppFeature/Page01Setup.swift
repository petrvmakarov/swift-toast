//
//  CodeSnippetDemo.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftUI

struct Page01Setup: View {
    var body: some View {
        PageLayout(
            title: "Setup",
            instructions: "1) invoke .withToast() modificator on the root view of your app",
            code: Self.setupCode,
            codeMaxHeight: 220
        )
        PageLayout(
            instructions: "2) use environment function 'showToast' to present your toast",
            code: Self.step02,
            codeMaxHeight: 220
        )
    }

    private static let setupCode = """
    import SwiftUI
    import SwiftToast

    struct ContentView: View {
        var body: some View {
            ToastExamples()
                .withToast()
        }
    }
    """
    
    private static let step02 = """
    private struct AppScreen: View {
        @Environment(\\.showToast)
        private var showToast

        var body: some View {
            List()
        }
    }
    """
}

#Preview {
    Page01Setup()
}
