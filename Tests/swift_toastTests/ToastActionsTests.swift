import SwiftUI
import Testing
@testable import SwiftToast

@Suite("Show toast action")
struct ShowToastActionTests {
    @MainActor
    @Test("Default arguments use top placement and two-second duration")
    func defaultArguments() {
        var receivedID: UUID?
        var receivedPlacement: ToastPlacement?
        var receivedDuration: TimeInterval?
        let action = ShowToastAction { type, placement, duration in
            receivedID = type.id
            receivedPlacement = placement
            receivedDuration = duration
        }
        let toast = ToastType.info(title: "Info")

        action(toast)

        #expect(receivedID == toast.id)
        #expect(receivedPlacement == .top)
        #expect(receivedDuration == 2)
    }

    @MainActor
    @Test("Explicit arguments are forwarded")
    func explicitArguments() {
        var receivedPlacement: ToastPlacement?
        var receivedDuration: TimeInterval?
        let action = ShowToastAction { _, placement, duration in
            receivedPlacement = placement
            receivedDuration = duration
        }

        action(
            ToastType.error(title: "Error"),
            placement: .bottom,
            dismissAfter: 7.5
        )

        #expect(receivedPlacement == .bottom)
        #expect(receivedDuration == 7.5)
    }
}

@Suite("Toast types")
struct ToastTypeTests {
    @MainActor
    @Test("Each toast receives a unique identity")
    func uniqueIdentity() {
        let first = ToastType.info()
        let second = ToastType.info()

        #expect(first.id != second.id)
    }

    @Test("Title and message values are retained")
    func titleAndMessageValues() {
        let value = TitleAndMessage(title: "Title", message: "Message")

        #expect(value.title.map { String($0) } == "Title")
        #expect(value.message.map { String($0) } == "Message")
    }

    @MainActor
    @Test("Custom presentation forwards its data to the renderer")
    func customPresentationData() {
        var receivedValue: Int?
        let presentation = ToastPresentationOptions<Int> { value in
            receivedValue = value
            return EmptyView()
        }

        _ = presentation.renderMessage(42)

        #expect(receivedValue == 42)
    }
}
