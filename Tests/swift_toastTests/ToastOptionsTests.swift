import SwiftUI
import Testing
@testable import SwiftToast

@Suite("Toast options")
struct ToastOptionsTests {
    @Test("Merging nil options preserves existing values")
    func mergeNilOptions() {
        let defaults = ToastOptions(
            iconSystemName: "base-icon",
            buttonSystemName: "base-button",
            liquidGlassEnabled: true
        )

        let merged = defaults.merge(with: nil)

        #expect(merged.iconSystemName == "base-icon")
        #expect(merged.buttonSystemName == "base-button")
        #expect(merged.liquidGlassEnabled)
    }

    @Test("User values override toast defaults")
    func mergeUserOptions() {
        let defaults = ToastOptions(
            iconSystemName: "base-icon",
            buttonSystemName: "base-button",
            liquidGlassEnabled: false
        )
        let userOptions = ToastConfiguration(
            iconSystemName: "custom-icon",
            buttonSystemName: "custom-button",
            liquidGlassEnabled: true
        )

        let merged = defaults.merge(with: userOptions)

        #expect(merged.iconSystemName == "custom-icon")
        #expect(merged.buttonSystemName == "custom-button")
        #expect(merged.liquidGlassEnabled)
    }

    @Test("Unspecified user values preserve toast defaults")
    func mergePartialUserOptions() {
        let defaults = ToastOptions(
            iconSystemName: "base-icon",
            buttonSystemName: "base-button",
            liquidGlassEnabled: true
        )

        let merged = defaults.merge(with: ToastConfiguration(iconSystemName: "custom-icon"))

        #expect(merged.iconSystemName == "custom-icon")
        #expect(merged.buttonSystemName == "base-button")
        #expect(merged.liquidGlassEnabled)
    }

    @Test("A user color is used for regular and liquid-glass appearances")
    func colorOverrideAppliesToBothAppearances() {
        let merged = ToastOptions.default.merge(
            with: ToastConfiguration(titleColor: .red)
        )

        #expect(merged.titleColor.regular == .red)
        #expect(merged.titleColor.liquidGlass == .red)
    }

    @Test("User tap handler is retained")
    func onTapHandler() {
        var tapCount = 0
        let options = ToastConfiguration {
            tapCount += 1
        }

        options.onTap?()

        #expect(tapCount == 1)
    }
}

@Suite("Toast container view options")
struct ToastContainerViewOptionsTests {
    @Test("Container defaults are stable")
    func defaults() {
        let options = ToastContainerViewOptions.default

        #expect(options.cornerRadius == 32)
        #expect(options.internalSpacing == 15)
        #expect(options.externalSpacing == 15)
        #expect(!options.liquidGlassEnabled)
        #expect(!options.stretched)
        #expect(options.ignoreSafeArea.isEmpty)
    }

    @Test("Explicit container values override defaults")
    func explicitValues() {
        let options = ToastContainerViewOptions(
            cornerRadius: 12,
            internalSpacing: 4,
            externalSpacing: 8,
            liquidGlassEnabled: true,
            stretched: true,
            ignoreSafeArea: [.top, .horizontal]
        )

        #expect(options.cornerRadius == 12)
        #expect(options.internalSpacing == 4)
        #expect(options.externalSpacing == 8)
        #expect(options.liquidGlassEnabled)
        #expect(options.stretched)
        #expect(options.ignoreSafeArea == [.top, .horizontal])
    }
}
