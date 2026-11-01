//
//  DemoPagesScreen.swift
//  SwiftToast
//
//  Created by Codex on 01/11/2026.
//

import SwiftUI

struct DemoPagesScreen: View {
    @State private var selectedPage: Page = .setup

    var body: some View {
        TabView(selection: $selectedPage) {
            page(Page01Setup())
                .tag(Page.setup)

            page(Page02())
                .tag(Page.predefinedToasts)

            page(Page03CustomError())
                .tag(Page.customError)

            page(Page04Undo())
                .tag(Page.undo)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private func page<Content: View>(_ content: Content) -> some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 44)
        }
    }
}

private extension DemoPagesScreen {
    enum Page: Hashable {
        case setup
        case predefinedToasts
        case customError
        case undo
    }
}

#Preview {
    DemoPagesScreen()
}
