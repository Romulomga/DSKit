import SwiftUI

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue: DSTheme = .default
}

public extension EnvironmentValues {
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

public extension View {
    /// Inject a `DSTheme` and the matching SwiftUI `tint` in one call.
    func microToolsTheme(_ theme: DSTheme) -> some View {
        self.environment(\.dsTheme, theme)
            .tint(theme.primary)
    }
}
