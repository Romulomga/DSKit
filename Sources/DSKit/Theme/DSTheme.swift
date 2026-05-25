import SwiftUI

/// Per-app theme. Consumers override the primary tint and app name; everything
/// else stays Apple-native via `DSColor` semantic colors.
public struct DSTheme: Sendable {
    public var appName: String
    public var primary: Color
    public var secondary: Color
    public var accent: Color

    public init(
        appName: String = "MicroTool",
        primary: Color = DSColor.primary,
        secondary: Color = DSColor.secondary,
        accent: Color? = nil
    ) {
        self.appName = appName
        self.primary = primary
        self.secondary = secondary
        self.accent = accent ?? primary
    }

    public static let `default` = DSTheme()
}
