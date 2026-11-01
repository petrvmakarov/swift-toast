//
//  ToasterArtwork.swift
//  SwiftToast
//
//  Created by Codex on 01/11/2026.
//

import SwiftUI

struct ToasterArtwork: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let onAnimationCompleted: () -> Void

    @State private var toastOffset: CGFloat = -44
    @State private var toastRotation: Double = 0
    @State private var toastScaleY: CGFloat = 0.96
    @State private var toastScaleX: CGFloat = 0.96
    @State private var toasterOffset: CGFloat = 0
    @State private var handleOffset: CGFloat = 0
    @State private var isTitleVisible = false

    init(onAnimationCompleted: @escaping () -> Void = {}) {
        self.onAnimationCompleted = onAnimationCompleted
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("toaster", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 220)
                .offset(y: toasterOffset)

            Image("toast", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .scaleEffect(x: toastScaleX, y: toastScaleY, anchor: .bottom)
                .rotationEffect(.degrees(toastRotation), anchor: .bottom)
                .offset(x: -5, y: toastOffset)
                .shadow(color: .black.opacity(0.22), radius: 7, y: 5)

            Image("toasterFront", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 243)
                .offset(y: toasterOffset)

            Image("toasterHandle", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .offset(x: 105, y: -70 + toasterOffset + handleOffset)

            VStack(spacing: 2) {
                Text("Swift Toast")
                    .font(.title.bold())

                Text("example app")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .opacity(isTitleVisible ? 1 : 0)
            .offset(y: isTitleVisible ? -55 : -35)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .frame(height: 530, alignment: .bottom)
        .clipped()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Swift Toast example app")
        .task {
            let clock = ContinuousClock()
            let splashDeadline = clock.now.advanced(by: .seconds(5))

            if reduceMotion {
                toastOffset = -112
                toastScaleX = 1
                toastScaleY = 1
                isTitleVisible = true
            } else {
                await playPopupAnimation()
            }

            try? await clock.sleep(until: splashDeadline)
            guard !Task.isCancelled else { return }
            onAnimationCompleted()
        }
    }

    @MainActor
    private func playPopupAnimation() async {
        // The heating element releases: the toast dips for anticipation while
        // the toaster and handle absorb a little downward force.
        try? await Task.sleep(for: .milliseconds(350))
        guard !Task.isCancelled else { return }

        withAnimation(.easeIn(duration: 0.16)) {
            toastOffset = -36
            toastScaleY = 0.88
            toasterOffset = 3
            handleOffset = 4
        }

        try? await Task.sleep(for: .milliseconds(160))
        guard !Task.isCancelled else { return }

        // A fast, slightly uneven spring launch keeps the motion from feeling
        // mechanically perfect.
        withAnimation(.interpolatingSpring(stiffness: 420, damping: 19)) {
            toastOffset = -145
            toastRotation = -5
            toastScaleY = 1.04
            toasterOffset = -2
            handleOffset = -2
        }

        try? await Task.sleep(for: .milliseconds(300))
        guard !Task.isCancelled else { return }

        // Gravity pulls the toast back toward the slot.
        withAnimation(.easeIn(duration: 0.2)) {
            toastOffset = -108
            toastRotation = 2
            toastScaleY = 1
            toasterOffset = 1
            handleOffset = 1
        }

        try? await Task.sleep(for: .milliseconds(200))
        guard !Task.isCancelled else { return }

        // Finish with a small damped bounce instead of stopping abruptly.
        withAnimation(.spring(response: 0.32, dampingFraction: 0.58)) {
            toastOffset = -116
            toastRotation = 0
            toasterOffset = 0
            handleOffset = 0
        }

        try? await Task.sleep(for: .milliseconds(650))
        guard !Task.isCancelled else { return }

        // Clear the stage for the next part of the introduction: the toaster
        // drops below the clipped frame while the toast lifts a little higher.
        withAnimation(.easeInOut(duration: 0.55)) {
            toasterOffset = 250
            toastOffset = -156
            toastRotation = -1
            toastScaleX = 2.5
            toastScaleY = 2.5
            isTitleVisible = true
        }
    }
}

#Preview {
    ToasterArtwork()
        .padding()
}
