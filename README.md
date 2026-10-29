# SwiftToast

[![Version](https://img.shields.io/github/v/tag/petrvmakarov/swift-toast?sort=semver&label=version)](https://github.com/petrvmakarov/swift-toast/tags)
[![Swift](https://img.shields.io/badge/Swift-6.4-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2018%2B%20%7C%20Mac%20Catalyst%2018%2B-lightgrey?logo=apple)](https://github.com/petrvmakarov/swift-toast)
[![License](https://img.shields.io/github/license/petrvmakarov/swift-toast)](https://github.com/petrvmakarov/swift-toast/blob/main/LICENSE)

SwiftToast is a SwiftUI toast library for iOS and Mac Catalyst. It includes four predefined toast styles, fully custom toast content, top and bottom placement, automatic dismissal, animated transitions, Liquid Glass support, and optional swipe-to-dismiss behavior.

## Requirements

- Swift 6.4+
- iOS 18+
- Mac Catalyst 18+

Liquid Glass is available on supported OS versions starting with iOS and Mac Catalyst 26. When it is unavailable, the toast uses its regular background style.

## Installation

Add this repository as a Swift Package dependency in Xcode, or add it to `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/petrvmakarov/swift-toast.git",
        exact: "0.0.8"
    )
]
```

Then add the `SwiftToast` product to your target and import the module:

```swift
import SwiftToast
```

## Basic usage

Apply `withToast()` once to a view above every view that needs to present a toast:

```swift
import SwiftUI
import SwiftToast

struct ContentView: View {
    var body: some View {
        ToastExamples()
            .withToast()
    }
}
```

Read `showToast` from the environment and call it with a `ToastType`:

```swift
struct ToastExamples: View {
    @Environment(\.showToast) private var showToast

    var body: some View {
        Button("Show success") {
            showToast(
                .success(
                    title: "Saved",
                    message: "Your changes were saved."
                )
            )
        }
    }
}
```

The default placement is `.top`, and the default display duration is two seconds.

## Predefined toast types

SwiftToast provides four built-in styles:

```swift
showToast(.info(title: "Information", message: "A new version is available."))
showToast(.success(title: "Complete", message: "The upload finished."))
showToast(.warning(title: "Warning", message: "Your session expires soon."))
showToast(.error(title: "Failed", message: "The request could not be completed."))
```

Both `title` and `message` are optional and accept any `StringProtocol` value.

## Placement and duration

Pass a placement and duration when presenting the toast:

```swift
showToast(
    .info(title: "Connected"),
    placement: .bottom,
    dismissAfter: 4
)
```

Available placements are `.top` and `.bottom`. The transition and swipe direction automatically follow the selected placement.

## Styling predefined toasts

Use `ToastConfiguration` to override the defaults of a predefined toast:

```swift
showToast(
    .error(
        title: "Upload failed",
        message: "Check your connection and try again.",
        options: ToastConfiguration(
            iconSystemName: "wifi.exclamationmark",
            iconColor: .white,
            buttonSystemName: "arrow.clockwise",
            buttonTint: .white,
            buttonBackground: .black.opacity(0.2),
            titleFont: .headline,
            titleColor: .white,
            messageFont: .subheadline,
            messageColor: .white.opacity(0.9),
            background: .red,
            liquidGlassEnabled: false,
            container: .init(
                cornerRadius: 16,
                internalSpacing: 12,
                externalSpacing: 16,
                stretched: true,
                ignoreSafeArea: []
            )
        )
    ),
    placement: .top
)
```

Unspecified values retain the defaults for the selected toast type.

### Liquid Glass

Enable Liquid Glass through the toast configuration:

```swift
showToast(
    .info(
        title: "Liquid Glass",
        message: "Uses the system glass effect when available.",
        options: ToastConfiguration(liquidGlassEnabled: true)
    )
)
```

On older OS versions, the toast automatically falls back to its regular appearance.

### Action button

When `onTap` is omitted, the trailing button dismisses the toast. Supplying `onTap` replaces that behavior with a custom action. Call `dismissToast()` yourself if the action should also close the toast:

```swift
struct RetryButton: View {
    @Environment(\.showToast) private var showToast
    @Environment(\.dismissToast) private var dismissToast

    var body: some View {
        Button("Start upload") {
            showToast(
                .error(
                    title: "Upload failed",
                    options: ToastConfiguration(
                        buttonSystemName: "arrow.clockwise",
                        onTap: {
                            dismissToast()
                            retryUpload()
                        }
                    )
                )
            )
        }
    }

    private func retryUpload() {
        // Retry the operation.
    }
}
```

## Programmatic dismissal

Use `dismissToast` from the environment to dismiss the currently visible toast:

```swift
@Environment(\.dismissToast) private var dismissToast

Button("Dismiss toast") {
    dismissToast()
}
```

## Swipe to dismiss

Swipe-to-dismiss is enabled by default. A top toast dismisses upward, and a bottom toast dismisses downward.

Disable dismissal through `ToastModifierOptions`:

```swift
ContentView()
    .withToast(
        ToastModifierOptions(swipeToDismissEnabled: false)
    )
```

When disabled, the toast still follows the drag gesture but returns to its initial position when released.

The option can also be changed dynamically:

```swift
struct RootView: View {
    @State private var swipeToDismissEnabled = true

    var body: some View {
        VStack {
            Toggle("Swipe to dismiss", isOn: $swipeToDismissEnabled)
            AppContent()
        }
        .withToast(
            .init(swipeToDismissEnabled: swipeToDismissEnabled)
        )
    }
}
```

## Custom toast content

Use `ToastType.custom` with `ToastPresentationOptions` to provide your own message and accessory views. Custom data must conform to `Hashable`.

`ToastContainerViewOptions` exposes mutable public properties. Start with `.default` and change the values required by your design:

```swift
struct Download: Hashable {
    let filename: String
    let progress: Double
}

@MainActor
private func downloadToast(_ download: Download) -> ToastType {
    var container = ToastContainerViewOptions.default
    container.backgroundColor = .blue.opacity(0.9)
    container.cornerRadius = 18
    container.stretched = true

    let presentation = ToastPresentationOptions<Download>(
        messageViewOptions: container,
        renderMessage: { download in
            VStack(alignment: .leading) {
                Text(download.filename).bold()
                ProgressView(value: download.progress)
            }
            .foregroundStyle(.white)
        },
        renderLeftAccessory: { _ in
            Image(systemName: "arrow.down.circle.fill")
                .foregroundStyle(.white)
        },
        renderRightAccessory: { _ in
            Image(systemName: "xmark")
                .foregroundStyle(.white)
        }
    )

    return .custom(download, presentation)
}
```

Present it in the same way as a predefined toast:

```swift
showToast(
    downloadToast(
        Download(filename: "report.pdf", progress: 0.65)
    ),
    placement: .bottom,
    dismissAfter: 5
)
```

The custom accessory closures render content only; add any desired button behavior directly inside those views.

## Image components

The package exposes `ImageAccessory` and `ImageButton` for use in custom toast content:

```swift
ImageAccessory(
    .systemName("checkmark.circle.fill"),
    withOptions: .init(foregroundColor: .green)
)

ImageButton(
    .systemName("xmark"),
    withOptions: .init(
        foregroundColor: .red,
        backgroundColor: .red.opacity(0.2),
        hideBackground: false
    )
) {
    dismissToast()
}
```

`ImageSource` supports SF Symbols, asset names, `UIImage`, `CGImage`, and SwiftUI `Image` values.

## API overview

| API | Purpose |
| --- | --- |
| `View.withToast(_:)` | Installs toast presentation and environment actions. |
| `showToast` | Presents a toast with optional placement and duration. |
| `dismissToast` | Dismisses the visible toast. |
| `ToastType` | Defines predefined or custom toast content. |
| `ToastConfiguration` | Overrides predefined toast appearance and action behavior. |
| `ToastConfiguration.ContainerOverrides` | Configures container layout and safe-area behavior. |
| `ToastModifierOptions` | Enables or disables swipe-to-dismiss. |
| `ToastPresentationOptions` | Supplies custom message and accessory renderers. |
| `ToastContainerViewOptions` | Controls the container used by custom toasts. |
| `ToastPlacement` | Selects top or bottom presentation. |

## Example app

The `Example` directory contains an app demonstrating predefined styles, custom configuration, Liquid Glass, placement selection, and swipe-to-dismiss controls.

## License

SwiftToast is available under the MIT License. See [LICENSE](LICENSE) for details.
