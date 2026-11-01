import SwiftToast
import SwiftUI

/// A deterministic presentation used to capture the README media.
/// Launch the example app with `--readme-demo` to run it.
struct ReadmeDemoScreen: View {
    @Environment(\.showToast) private var showToast
    @State private var activeStyle = "Information"
    @State private var placement = "Top placement"

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Image("toast", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 116)
                    .shadow(color: .orange.opacity(0.2), radius: 18, y: 10)

                VStack(spacing: 6) {
                    Text("SwiftToast")
                        .font(.largeTitle.bold())

                    Text("Beautiful feedback in one modifier")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 14) {
                    HStack {
                        Label(activeStyle, systemImage: "sparkles")
                            .font(.headline)

                        Spacer()

                        Text(placement)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 8) {
                        stylePill("Info", color: .blue)
                        stylePill("Success", color: .green)
                        stylePill("Warning", color: .orange)
                        stylePill("Error", color: .red)
                    }
                }
                .padding(18)
                .background(.background, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: .black.opacity(0.07), radius: 18, y: 8)
                .padding(.horizontal, 22)

                Spacer()

                Text("SwiftUI  •  iOS 18+")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 28)
            }
        }
        .task {
            await runDemoLoop()
        }
    }

    private func stylePill(_ title: String, color: Color) -> some View {
        Text(title)
            .font(.caption2.weight(.bold))
            .foregroundStyle(color)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(color.opacity(0.12), in: Capsule())
    }

    @MainActor
    private func runDemoLoop() async {
        try? await Task.sleep(for: .milliseconds(600))

        while !Task.isCancelled {
            present(
                style: "Information",
                placementLabel: "Top placement",
                toast: .info(title: "Heads up", message: "A fresh update is ready."),
                placement: .top
            )
            try? await Task.sleep(for: .milliseconds(1_550))

            present(
                style: "Success",
                placementLabel: "Top placement",
                toast: .success(title: "Saved", message: "Your changes are safe."),
                placement: .top
            )
            try? await Task.sleep(for: .milliseconds(1_550))

            present(
                style: "Warning",
                placementLabel: "Top placement",
                toast: .warning(title: "Almost full", message: "Storage is running low."),
                placement: .top
            )
            try? await Task.sleep(for: .milliseconds(1_550))

            present(
                style: "Error",
                placementLabel: "Top placement",
                toast: .error(title: "Upload failed", message: "Check your connection."),
                placement: .top
            )
            try? await Task.sleep(for: .milliseconds(1_550))

            activeStyle = "Undo action"
            placement = "Bottom placement"
            showToast(
                .undo(
                    "Item deleted",
                    message: "Tap to undo",
                    options: .init(
                        duration: 2.4,
                        tint: .cyan,
                        liquidGlassEnabled: true,
                        onButtonTap: {}
                    )
                ),
                placement: .bottom,
                dismissAfter: 2.4
            )
            try? await Task.sleep(for: .milliseconds(2_900))
        }
    }

    @MainActor
    private func present(
        style: String,
        placementLabel: String,
        toast: ToastType,
        placement toastPlacement: ToastPlacement
    ) {
        activeStyle = style
        placement = placementLabel
        showToast(toast, placement: toastPlacement, dismissAfter: 1.2)
    }
}

#Preview {
    ReadmeDemoScreen()
        .withToast()
}
