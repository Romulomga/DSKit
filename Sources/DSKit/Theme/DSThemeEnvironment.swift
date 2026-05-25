import SwiftUI

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue: DSTheme = .default
}

private struct DSHapticsEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

public extension EnvironmentValues {
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }

    /// Global on/off switch for `DSHaptics` triggered by DSKit components.
    /// Wire it to the user's "Haptics" setting at the app root.
    var dsHapticsEnabled: Bool {
        get { self[DSHapticsEnabledKey.self] }
        set { self[DSHapticsEnabledKey.self] = newValue }
    }
}

public extension View {
    /// Inject a `DSTheme` and the matching SwiftUI `tint` in one call.
    func dsTheme(_ theme: DSTheme) -> some View {
        self.environment(\.dsTheme, theme)
            .tint(theme.primary)
    }

    /// Toggle haptic feedback from DSKit components on/off for the whole subtree.
    func dsHapticsEnabled(_ enabled: Bool) -> some View {
        self.environment(\.dsHapticsEnabled, enabled)
    }

    @available(*, deprecated, renamed: "dsTheme")
    func microToolsTheme(_ theme: DSTheme) -> some View {
        dsTheme(theme)
    }
}
