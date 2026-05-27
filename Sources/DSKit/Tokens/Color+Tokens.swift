import SwiftUI

public extension Color {
    init(named name: String) {
        self = Color(name, bundle: Bundle.mainIfAvailable)
    }

    /// Background color, hex value Light **#FFFFFF** Dark **#1A1A1A**
    static let background = Color("Background", bundle: .module)

    /// Light brand wash, hex value Light **#EFE7FA** Dark **#EFE7FA**
    static let appColorLight = Color("AppColorLight", bundle: .module)

    /// Surface color, hex value Light **#F0F0F9** Dark **#313131**
    static let surface = Color("Surface", bundle: .module)

    /// On Surface High color, hex value Light **#101010** Dark **#D1D1D1**
    static let onSurfaceHigh = Color("OnSurfaceHigh", bundle: .module)

    /// On Surface Medium color, hex value Light **#5E5E5E** Dark **#A3A3A3**
    static let onSurfaceMedium = Color("OnSurfaceMedium", bundle: .module)

    /// On Surface Light color, hex value Light **#BCBCBC** Dark **#535353**
    static let onSurfaceLight = Color("OnSurfaceLight", bundle: .module)

    /// Border color, hex value Light **#E5E5E5** Dark **#414141**
    static let border = Color("Border", bundle: .module)

    /// Brand accent — overridable per host app. DSKit default is `systemIndigo`.
    static let accent = Color("Accent", bundle: .mainIfAvailable)

    /// Secondary brand accent — overridable per host app. DSKit default is `systemPink`.
    static let accentSecondary = Color("AccentSecondary", bundle: .mainIfAvailable)

    /// Contrasting color for text/icons on top of `accent`/`accentSecondary`.
    /// Overridable per host app. DSKit default is **#FFFFFF**.
    static let onAccent = Color("OnAccent", bundle: .mainIfAvailable)

    /// Success Light, hex value Light **#B0F3F5** Dark **#B0F3F5**
    static let successLight = Color("SuccessLight", bundle: .module)

    /// Success High, hex value Light **#27BAA7** Dark **#27BAA7**
    static let successHigh = Color("SuccessHigh", bundle: .module)

    /// Warning Light, hex value Light **#FCFBBC** Dark **#FCFBBC**
    static let warningLight = Color("WarningLight", bundle: .module)

    /// Warning High, hex value Light **#F1DA10** Dark **#F1DA10**
    static let warningHigh = Color("WarningHigh", bundle: .module)

    /// Info Light, hex value Light **#D7E4EC** Dark **#D7E4EC**
    static let infoLight = Color("InfoLight", bundle: .module)

    /// Info High, hex value Light **#54AADF** Dark **#54AADF**
    static let infoHigh = Color("InfoHigh", bundle: .module)

    /// Error Light, hex value Light **#FFB2A3** Dark **#FFB2A3**
    static let errorLight = Color("ErrorLight", bundle: .module)

    /// Error High, hex value Light **#FF4425** Dark **#FF4425**
    static let errorHigh = Color("ErrorHigh", bundle: .module)

    /// Disabled background, hex value Light **#DCDBDC** Dark **#A4A4A4**
    static let disabled = Color("Disabled", bundle: .module)

    /// On Disabled, hex value Light **#BCBCBC** Dark **#707070**
    static let onDisabled = Color("OnDisabled", bundle: .module)
}

extension Bundle {
    /// Returns the host app's main bundle when available, falling back to the
    /// DSKit module bundle in environments where main is the preview agent or
    /// missing entirely. Lets DSKit ship sensible defaults that the host app
    /// can override per-asset by adding a matching `.colorset` to its own
    /// asset catalog.
    static var mainIfAvailable: Bundle {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return .module
        }
        return !bundleIdentifier.lowercased().contains("previewagent") ? .main : .module
    }
}
