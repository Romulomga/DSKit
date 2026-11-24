import SwiftUI
import Testing
import UIKit
@testable import DSKit

/// The soft status backgrounds (`successLight`, `warningLight`, `infoLight`, `errorLight`) change with the appearance,
/// and the app's text on them stays readable in both: in 1.0.50 they were the same light colors in dark mode, and the
/// light `onSurface` text over them couldn't be read (the Minha Micro Área's backup banner, 24/11).
@MainActor
struct StatusColorTests {
    private static let softBackgrounds: [Color] = [.successLight, .warningLight, .infoLight, .errorLight]

    private func resolved(_ color: Color, _ style: UIUserInterfaceStyle) -> UIColor {
        UIColor(color).resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
    }

    private func luminance(_ color: UIColor) -> Double {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        func linear(_ value: CGFloat) -> Double {
            let value = Double(value)
            return value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
    }

    private func contrast(_ lhs: UIColor, _ rhs: UIColor) -> Double {
        let (a, b) = (luminance(lhs), luminance(rhs))
        return (max(a, b) + 0.05) / (min(a, b) + 0.05)
    }

    @Test(arguments: [UIUserInterfaceStyle.light, .dark])
    func textOnASoftBackgroundIsReadable(_ style: UIUserInterfaceStyle) {
        for background in Self.softBackgrounds {
            let surface = resolved(background, style)

            #expect(contrast(resolved(.onSurfaceHigh, style), surface) >= 7)
            #expect(contrast(resolved(.onSurfaceMedium, style), surface) >= 4.5)
        }
    }
}
