//
//  CodeView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftUI
import UIKit
import WebKit

struct CodeView: View {
    let code: String
    @State private var isCopied = false

    var body: some View {
        CodeWebView(code: code)
            .overlay(alignment: .topTrailing) {
                Button {
                    UIPasteboard.general.string = code
                    isCopied = true
                } label: {
                    Label(
                        isCopied ? "Copied" : "Copy",
                        systemImage: isCopied ? "checkmark" : "doc.on.doc"
                    )
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(.regularMaterial, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(10)
                .accessibilityHint("Copies the displayed code to the clipboard")
            }
            .onChange(of: code) {
                isCopied = false
            }
    }
}

private struct CodeWebView: UIViewRepresentable {
    let code: String

    func makeCoordinator() -> Coordinator {
        Coordinator(code: code)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false

        if let url = Bundle.module.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "CodeHighlight"
        ) {
            webView.loadFileURL(
                url,
                allowingReadAccessTo:
                    url.deletingLastPathComponent()
            )
        }

        return webView
    }

    func updateUIView(
        _ webView: WKWebView,
        context: Context
    ) {
        context.coordinator.updateCode(code, in: webView)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var code: String
        private var isLoaded = false

        init(code: String) {
            self.code = code
        }

        func updateCode(_ newCode: String, in webView: WKWebView) {
            guard code != newCode else {
                return
            }

            code = newCode

            guard isLoaded else {
                return
            }

            isLoaded = false
            webView.reload()
        }

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            isLoaded = true
            injectCode(into: webView)
        }

        func injectCode(into webView: WKWebView) {
            guard
                isLoaded,
                let data = try? JSONEncoder().encode(code),
                let encodedCode = String(data: data, encoding: .utf8)
            else {
                return
            }

            webView.evaluateJavaScript(
                """
                const element = document.querySelector('pre code');
                element.textContent = \(encodedCode);
                element.removeAttribute('data-highlighted');
                hljs.highlightElement(element);
                """
            )
        }
    }
}

#Preview {
    CodeView(code: """
    import SwiftUI

    struct ContentView: View {
        @State private var count = 0

        var body: some View {
            Button("Count: \\(count)") {
                count += 1
            }
        }
    }
    """)
}
