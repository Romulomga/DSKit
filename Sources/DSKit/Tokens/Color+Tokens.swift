import SwiftUI

public extension Color {
    init(named name: String) {
        self = Color(name, bundle: Bundle.mainIfAvailable)
    }

    /// Background color, hex value Light **#FFFFFF** Dark **#121212**.
    /// Overridable: a host app ships a `DSBackground` colorset to replace it.
    static let background = Color.overridable("Background")

    /// Light brand wash, hex value Light **#EFE7FA** Dark **#EFE7FA**
    static let appColorLight = Color("AppColorLight", bundle: .module)

    /// Grouped canvas — the iOS Settings backdrop. Hex value Light **#F2F2F7** Dark **#0A0A0A**.
    /// Pair with `surfaceElevated` cells; `surface` is too close in tone to read on it.
    /// Overridable: a host app ships a `DSBackgroundGrouped` colorset to replace it.
    static let backgroundGrouped = Color.overridable("BackgroundGrouped")

    /// Surface color, hex value Light **#F0F0F9** Dark **#1E1E1E**.
    /// Overridable: a host app ships a `DSSurface` colorset to replace it.
    static let surface = Color.overridable("Surface")

    /// One step up from `surface`: cells on a grouped canvas, or an input /
    /// chip nested inside a card so it doesn't vanish surface-on-surface.
    /// Hex value Light **#FFFFFF** Dark **#2A2A2A**
    /// Overridable: a host app ships a `DSSurfaceElevated` colorset to replace it.
    static let surfaceElevated = Color.overridable("SurfaceElevated")

    /// Surface for a given nesting level (see `EnvironmentValues.dsSurfaceLevel`):
    /// level 0 sits on the canvas and uses `surface`; anything deeper uses
    /// `surfaceElevated`.
    static func surface(level: Int) -> Color {
        level > 0 ? .surfaceElevated : .surface
    }

    /// On Surface High color, hex value Light **#101010** Dark **#EDEDED**
    /// Overridable: a host app ships a `DSOnSurfaceHigh` colorset to replace it.
    static let onSurfaceHigh = Color.overridable("OnSurfaceHigh")

    /// On Surface Medium color, hex value Light **#5E5E5E** Dark **#B0B0B0**
    /// Overridable: a host app ships a `DSOnSurfaceMedium` colorset to replace it.
    static let onSurfaceMedium = Color.overridable("OnSurfaceMedium")

    /// On Surface Light color, hex value Light **#BCBCBC** Dark **#4A4A4A**
    /// Overridable: a host app ships a `DSOnSurfaceLight` colorset to replace it.
    static let onSurfaceLight = Color.overridable("OnSurfaceLight")

    /// Border color, hex value Light **#E5E5E5** Dark **#363636**.
    /// Full-strength; use for dividers. For the resting outline of a surface
    /// prefer `hairline`.
    /// Overridable: a host app ships a `DSBorder` colorset to replace it.
    static let border = Color.overridable("Border")

    /// Appearance-aware resting outline for cards and inputs. Light mode is a
    /// faint dark line (`border` at 50%); dark mode is a faint *light* line
    /// (**#FFFFFF** at 10%) because a dark hairline vanishes into a dark canvas.
    /// Overridable: a host app ships a `DSHairline` colorset to replace it.
    static let hairline = Color.overridable("Hairline")

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

public extension Color {
    /// Fill of `DSProBadge`. DSKit default is the brand accent (the environment
    /// tint). Overridable: a host app ships a `DSProBadge` colorset to replace it.
    static var proBadge: Color {
        hostOverride("ProBadge") ?? Color.accentColor
    }

    /// Label of `DSProBadge`. DSKit default is `onAccent`.
    /// Overridable: a host app ships a `DSOnProBadge` colorset to replace it.
    static var onProBadge: Color {
        hostOverride("OnProBadge") ?? Color.onAccent
    }

    /// Fill of a disabled filled control: the high text color at low strength,
    /// so it reads as "off" on any canvas and in any brand.
    static let disabledFill = Color.onSurfaceHigh.opacity(0.12)

    /// Label of a disabled control on `disabledFill`: dimmed but still ≥ 3:1.
    static let onDisabledFill = Color.onSurfaceHigh.opacity(0.62)
}

extension Color {
    /// The host app's `DS<token>` colorset, or nil when it ships none.
    static func hostOverride(_ token: String) -> Color? {
        let host = Bundle.mainIfAvailable
        let name = overrideName(for: token)

        guard host != .module, UIColor(named: name, in: host, compatibleWith: nil) != nil else { return nil }

        return Color(name, bundle: host)
    }

    /// The colorset name a host app uses to override a canvas, surface, text or outline token:
    /// `DS` + the token's own name. Prefixed — unlike the accent tokens — so
    /// an app that happens to have a "Background" or "Surface" colorset of its
    /// own never restyles DSKit by accident.
    static func overrideName(for token: String) -> String {
        "DS" + token
    }

    /// A canvas, surface, text or outline token: the host app's `DS<token>` colorset when it
    /// ships one, DSKit's own otherwise.
    static func overridable(_ token: String) -> Color {
        let host = Bundle.mainIfAvailable
        let name = overrideName(for: token)

        if host != .module, UIColor(named: name, in: host, compatibleWith: nil) != nil {
            return Color(name, bundle: host)
        }

        return Color(token, bundle: .module)
    }
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
