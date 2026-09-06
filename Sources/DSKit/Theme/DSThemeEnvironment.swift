import SwiftUI

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue: DSTheme = .default
}

private struct DSHapticsEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

private struct DSSurfaceLevelKey: EnvironmentKey {
    static let defaultValue: Int = 0
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

    /// How many DSKit surfaces enclose the current view. `0` means the view
    /// sits on the canvas. Surface components raise it for their content, so
    /// an input inside a card automatically renders on `Color.surfaceElevated`
    /// instead of disappearing surface-on-surface. `.dsGroupedCanvas()` starts
    /// it at `1` for the iOS Settings look.
    var dsSurfaceLevel: Int {
        get { self[DSSurfaceLevelKey.self] }
        set { self[DSSurfaceLevelKey.self] = newValue }
    }
}

/// Raises `dsSurfaceLevel` by one for the wrapped content. Applied by every
/// DSKit component that paints a surface.
struct DSSurfaceContainerModifier: ViewModifier {
    @Environment(\.dsSurfaceLevel) private var level

    func body(content: Content) -> some View {
        content.environment(\.dsSurfaceLevel, level + 1)
    }
}

extension View {
    /// Mark this view as a surface: its children read one nesting level deeper.
    func dsSurfaceContainer() -> some View {
        modifier(DSSurfaceContainerModifier())
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

    /// Paint `Color.backgroundGrouped` behind the view and start
    /// `dsSurfaceLevel` at `1`, so DSKit cards and inputs render on
    /// `Color.surfaceElevated` — the iOS Settings look (white cells on a
    /// light-gray canvas).
    func dsGroupedCanvas() -> some View {
        self.environment(\.dsSurfaceLevel, 1)
            .background(Color.backgroundGrouped.ignoresSafeArea())
    }

    @available(*, deprecated, renamed: "dsTheme")
    func microToolsTheme(_ theme: DSTheme) -> some View {
        dsTheme(theme)
    }
}
