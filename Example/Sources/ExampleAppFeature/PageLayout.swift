//
//  SwiftUIView.swift
//  SwiftToast
//
//  Created by Petr Makarov on 01/11/2026.
//

import SwiftUI

enum WalkthroughScrollTarget: Equatable {
    case top
    case bottom
}

private struct WalkthroughScrollTargetKey: EnvironmentKey {
    static let defaultValue: WalkthroughScrollTarget? = nil
}

private struct WalkthroughShowToastTriggerKey: EnvironmentKey {
    static let defaultValue = 0
}

extension EnvironmentValues {
    var walkthroughScrollTarget: WalkthroughScrollTarget? {
        get { self[WalkthroughScrollTargetKey.self] }
        set { self[WalkthroughScrollTargetKey.self] = newValue }
    }

    var walkthroughShowToastTrigger: Int {
        get { self[WalkthroughShowToastTriggerKey.self] }
        set { self[WalkthroughShowToastTriggerKey.self] = newValue }
    }
}

struct WalkthroughScrollView<Content: View>: View {
    @Environment(\.walkthroughScrollTarget) private var walkthroughScrollTarget
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Color.clear
                    .frame(height: 1)
                    .id(WalkthroughScrollTarget.top)

                content
                    .frame(maxWidth: .infinity, alignment: .top)

                Color.clear
                    .frame(height: 1)
                    .id(WalkthroughScrollTarget.bottom)
            }
            .onChange(of: walkthroughScrollTarget, initial: true) { _, target in
                guard let target else { return }

                withAnimation(.easeInOut(duration: 2.5)) {
                    proxy.scrollTo(
                        target,
                        anchor: target == .top ? .top : .bottom
                    )
                }
            }
        }
    }
}

struct PageLayout<Content: View>: View {
    private var title: String? = nil
    private var instructions: String? = nil
    private var code: String
    private var codeMaxHeight: CGFloat? = nil

    private let content: Content

    package init(title: String? = nil,
                 instructions: String? = nil,
                 code: String,
                 codeMaxHeight: CGFloat? = nil,
                 @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.title = title
        self.instructions = instructions
        self.code = code
        self.codeMaxHeight = codeMaxHeight
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if let title, !title.isEmpty {
                Header(title)
            }
            if let instructions, !instructions.isEmpty {
                InstructionCard(text: instructions)
            }
            CodeView(code: code)
                .frame(maxWidth: .infinity)
                .frame(height: codeMaxHeight)
            content
        }
        .padding()
    }
}

struct PinnedActionPage<Content: View, Action: View>: View {
    @Environment(\.walkthroughScrollTarget) private var walkthroughScrollTarget

    private let content: Content
    private let action: Action

    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder action: () -> Action
    ) {
        self.content = content()
        self.action = action()
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Color.clear
                    .frame(height: 1)
                    .id(WalkthroughScrollTarget.top)

                content
                    .frame(maxWidth: .infinity, alignment: .top)

                Color.clear
                    .frame(height: 1)
                    .id(WalkthroughScrollTarget.bottom)
            }
            .onChange(of: walkthroughScrollTarget, initial: true) { _, target in
                guard let target else { return }

                withAnimation(.easeInOut(duration: 2.5)) {
                    proxy.scrollTo(
                        target,
                        anchor: target == .top ? .top : .bottom
                    )
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            action
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 58)
        }
    }
}

private struct InstructionCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.tint)
                .frame(width: 28, height: 28)
                .background(Color.accentColor.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text("QUICK GUIDE")
                    .font(.caption2.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(.tint)

                Text(text)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.primary.opacity(0.07), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PageLayout(title: "Hello World", code: """
        import Foundation
        
        func main() {
            print("Hello world!")
        }
        """) {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
