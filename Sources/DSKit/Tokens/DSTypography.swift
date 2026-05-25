import SwiftUI

/// System fonts in semantic roles. Prefer these over `.system(size:)` so
/// Dynamic Type continues to scale text automatically.
public enum DSTypography {
    public static func largeTitle() -> Font { .system(.largeTitle, design: .default).weight(.bold) }
    public static func title() -> Font { .system(.title, design: .default).weight(.semibold) }
    public static func title2() -> Font { .system(.title2, design: .default).weight(.semibold) }
    public static func title3() -> Font { .system(.title3, design: .default).weight(.semibold) }
    public static func headline() -> Font { .system(.headline, design: .default) }
    public static func body() -> Font { .system(.body, design: .default) }
    public static func callout() -> Font { .system(.callout, design: .default) }
    public static func subheadline() -> Font { .system(.subheadline, design: .default) }
    public static func footnote() -> Font { .system(.footnote, design: .default) }
    public static func caption() -> Font { .system(.caption, design: .default) }
    public static func caption2() -> Font { .system(.caption2, design: .default) }

    /// Rounded display used by `DSResultCard` for highlighted results.
    public static func resultPrimary() -> Font {
        .system(.largeTitle, design: .rounded).weight(.bold)
    }

    public static func resultSecondary() -> Font {
        .system(.title2, design: .rounded).weight(.semibold)
    }
}
