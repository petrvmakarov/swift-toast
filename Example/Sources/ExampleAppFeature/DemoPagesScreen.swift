//
//  DemoPagesScreen.swift
//  SwiftToast
//
//  Created by Codex on 01/11/2026.
//

import SwiftToast
import SwiftUI

struct DemoPagesScreen: View {
    let isAutomatedWalkthrough: Bool

    @State private var selectedPage: Page = .setup
    @State private var walkthroughScrollTarget: WalkthroughScrollTarget? = nil
    @State private var walkthroughShowToastTrigger = 0

    @Environment(\.dismissToast) private var dismissToast

    init(isAutomatedWalkthrough: Bool = false) {
        self.isAutomatedWalkthrough = isAutomatedWalkthrough
    }

    var body: some View {
        TabView(selection: $selectedPage) {
            page(Page01Setup())
                .tag(Page.setup)
                .environment(
                    \.walkthroughScrollTarget,
                    selectedPage == .setup ? walkthroughScrollTarget : nil
                )

            Page02()
                .tag(Page.predefinedToasts)
                .environment(
                    \.walkthroughScrollTarget,
                    selectedPage == .predefinedToasts ? walkthroughScrollTarget : nil
                )
                .environment(
                    \.walkthroughShowToastTrigger,
                    selectedPage == .predefinedToasts ? walkthroughShowToastTrigger : 0
                )

            Page03CustomError()
                .tag(Page.customError)
                .environment(
                    \.walkthroughScrollTarget,
                    selectedPage == .customError ? walkthroughScrollTarget : nil
                )
                .environment(
                    \.walkthroughShowToastTrigger,
                    selectedPage == .customError ? walkthroughShowToastTrigger : 0
                )

            Page04Undo()
                .tag(Page.undo)
                .environment(
                    \.walkthroughScrollTarget,
                    selectedPage == .undo ? walkthroughScrollTarget : nil
                )
                .environment(
                    \.walkthroughShowToastTrigger,
                    selectedPage == .undo ? walkthroughShowToastTrigger : 0
                )
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .task {
            guard isAutomatedWalkthrough else { return }
            await runAutomatedWalkthrough()
        }
    }

    private func page<Content: View>(_ content: Content) -> some View {
        WalkthroughScrollView {
            content
                .padding(.bottom, 44)
        }
    }

    @MainActor
    private func runAutomatedWalkthrough() async {
        // Leave enough time for a recorder to attach after launching the app.
        try? await Task.sleep(for: .milliseconds(4_500))

        for page in Page.allCases {
            walkthroughScrollTarget = .top

            withAnimation(.easeInOut(duration: 0.55)) {
                selectedPage = page
            }

            try? await Task.sleep(for: .milliseconds(1_000))
            guard !Task.isCancelled else { return }

            walkthroughScrollTarget = .bottom
            try? await Task.sleep(for: .milliseconds(3_000))
            guard !Task.isCancelled else { return }

            if page.hasToastAction {
                walkthroughShowToastTrigger += 1
                try? await Task.sleep(for: .milliseconds(2_200))
                dismissToast()
                try? await Task.sleep(for: .milliseconds(500))
            } else {
                try? await Task.sleep(for: .milliseconds(500))
            }

            guard !Task.isCancelled else { return }
        }
    }
}

private extension DemoPagesScreen {
    enum Page: Hashable, CaseIterable {
        case setup
        case predefinedToasts
        case customError
        case undo

        var hasToastAction: Bool {
            self != .setup
        }
    }
}

#Preview {
    DemoPagesScreen()
        .withToast()
}
