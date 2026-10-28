#if canImport(UIKit)
import SwiftUI
import Testing
import UIKit
@testable import SwiftToast

@Suite("Color extensions")
struct ColorExtensionsTests {
    @Test("UIColor parses six-digit hex values")
    func uiColorHex() throws {
        let components = try components(of: UIColor(hex: "#336699"))

        #expect(abs(components.red - 0.2) < 0.001)
        #expect(abs(components.green - 0.4) < 0.001)
        #expect(abs(components.blue - 0.6) < 0.001)
        #expect(components.alpha == 1)
    }

    @Test("SwiftUI Color parses hex values with or without a prefix", arguments: ["#FF0000", "FF0000"])
    func swiftUIColorHex(_ hex: String) throws {
        let components = try components(of: UIColor(Color(hex: hex)))

        #expect(components.red == 1)
        #expect(components.green == 0)
        #expect(components.blue == 0)
        #expect(components.alpha == 1)
    }

    @Test("Image button derives a translucent background from its foreground")
    func derivedButtonBackground() throws {
        let options = ImageButtonOptions(foregroundColor: .red)
        let actual = try components(of: UIColor(options.actualBackgroundColor))
        let expected = try components(of: UIColor(Color.red))

        #expect(abs(actual.red - expected.red) < 0.001)
        #expect(abs(actual.green - expected.green) < 0.001)
        #expect(abs(actual.blue - expected.blue) < 0.001)
        #expect(abs(actual.alpha - 0.25) < 0.001)
    }

    @Test("Image button uses an explicit background")
    func explicitButtonBackground() throws {
        let options = ImageButtonOptions(
            foregroundColor: .red,
            backgroundColor: .blue
        )
        let actual = try components(of: UIColor(options.actualBackgroundColor))
        let expected = try components(of: UIColor(Color.blue))

        #expect(abs(actual.red - expected.red) < 0.001)
        #expect(abs(actual.green - expected.green) < 0.001)
        #expect(abs(actual.blue - expected.blue) < 0.001)
        #expect(abs(actual.alpha - expected.alpha) < 0.001)
    }

    private func components(
        of color: UIColor
    ) throws -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            throw ColorTestError.unavailableComponents
        }

        return (red, green, blue, alpha)
    }
}

private enum ColorTestError: Error {
    case unavailableComponents
}
#endif
