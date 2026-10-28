import Testing
@testable import swift_toast

@Suite("Constants")
struct KTests {
    @Test("Liquid glass availability matches the operating system")
    func liquidGlassAvailability() {
        let expected: Bool

        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, macCatalyst 26.0, *) {
            expected = true
        } else {
            expected = false
        }

        #expect(K.isLiquidGlassAvailable == expected)
    }
}
