import Testing
@testable import swift_toast

@Suite("Toast modifier options")
struct ToastModifierOptionsTests {
    @Test("Swipe to dismiss is enabled by default")
    func swipeToDismissDefault() {
        let options = ToastModifierOptions()

        #expect(options.swipeToDismissEnabled)
    }

    @Test("Swipe to dismiss can be disabled")
    func swipeToDismissDisabled() {
        let options = ToastModifierOptions(swipeToDismissEnabled: false)

        #expect(!options.swipeToDismissEnabled)
    }
}

@Suite("Swipe to dismiss behavior")
struct ToastSwipeToDismissBehaviorTests {
    @Test("Top toast only follows upward drags")
    func topToastDragDirection() {
        #expect(ToastSwipeToDismissBehavior.offset(for: -30, placement: .top) == -30)
        #expect(ToastSwipeToDismissBehavior.offset(for: 30, placement: .top) == 0)
    }

    @Test("Bottom toast only follows downward drags")
    func bottomToastDragDirection() {
        #expect(ToastSwipeToDismissBehavior.offset(for: 30, placement: .bottom) == 30)
        #expect(ToastSwipeToDismissBehavior.offset(for: -30, placement: .bottom) == 0)
    }

    @Test("Top toast dismisses after an upward swipe past the threshold")
    func topToastDismissal() {
        #expect(ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: -81,
            placement: .top,
            isEnabled: true
        ))
        #expect(!ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: -80,
            placement: .top,
            isEnabled: true
        ))
    }

    @Test("Bottom toast dismisses after a downward swipe past the threshold")
    func bottomToastDismissal() {
        #expect(ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: 81,
            placement: .bottom,
            isEnabled: true
        ))
        #expect(!ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: 80,
            placement: .bottom,
            isEnabled: true
        ))
    }

    @Test("Disabled swipe always returns the toast")
    func disabledSwipeDoesNotDismiss() {
        #expect(!ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: -500,
            placement: .top,
            isEnabled: false
        ))
        #expect(!ToastSwipeToDismissBehavior.shouldDismiss(
            predictedTranslation: 500,
            placement: .bottom,
            isEnabled: false
        ))
    }
}

@Suite("Toast container overrides")
struct ToastContainerOverridesTests {
    @Test("Container overrides preserve edge selections")
    func ignoreSafeAreaEdges() {
        let options = ToastConfiguration(
            container: .init(ignoreSafeArea: [.top, .bottom])
        )

        #expect(options.container.ignoreSafeArea == [.top, .bottom])
    }

    @Test("Legacy stretched value is applied when no container value is supplied")
    func legacyStretchedFallback() {
        let options = ToastConfiguration(stretched: true)

        #expect(options.container.stretched == true)
    }

    @Test("Container stretched value takes precedence")
    func containerStretchedPrecedence() {
        let options = ToastConfiguration(
            stretched: true,
            container: .init(stretched: false)
        )

        #expect(options.container.stretched == false)
    }
}
