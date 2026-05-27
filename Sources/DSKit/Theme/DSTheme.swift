import SwiftUI

/// Per-app theme. Consumers override the primary tint and app name; everything
/// else is driven by the asset-backed `Color` tokens declared in this module
/// (overridable per host app via matching `.colorset` names).
public struct DSTheme {
    public var appName: String
    public var primary: Color
    public var secondary: Color
    public var accent: Color

    public init(
        appName: String = "MicroTool",
        primary: Color = Color.accent,
        secondary: Color = Color.accent,
        accent: Color? = nil
    ) {
        self.appName = appName
        self.primary = primary
        self.secondary = secondary
        self.accent = accent ?? primary
    }

    public static let `default` = DSTheme()
}
