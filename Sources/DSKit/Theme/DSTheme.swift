import SwiftUI

/// Per-app theme. Consumers override the primary tint and app name; everything
/// else is driven by the asset-backed `Color` tokens declared in this module
/// (overridable per host app via matching `.colorset` names).
public struct DSTheme {
    public var appName: String
    public var primary: Color
    public var secondary: Color
    public var accent: Color
    /// Label and glyph color on a `primary` fill (filled buttons, selected
    /// chips and segments, icon tiles). Pair it with `primary`: a light
    /// primary needs a dark `onPrimary`.
    public var onPrimary: Color

    public init(
        appName: String = "MicroTool",
        primary: Color = Color.accent,
        secondary: Color = Color.accent,
        accent: Color? = nil,
        onPrimary: Color = Color.onAccent
    ) {
        self.appName = appName
        self.primary = primary
        self.secondary = secondary
        self.accent = accent ?? primary
        self.onPrimary = onPrimary
    }

    public static let `default` = DSTheme()
}
