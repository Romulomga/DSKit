import SwiftUI
import UIKit

/// Semantic font roles. Prefer these over `.system(size:)` so Dynamic Type
/// continues to scale text automatically.
///
/// Every token resolves to the system font unless the host app installs a
/// custom family via `DSTypography.family`.
public enum DSTypography {

    /// Custom family applied by every token; `nil` (the default) keeps the
    /// system font. Set it once at app launch, before the first view renders:
    ///
    ///     DSTypography.family = DSFontFamily("Nunito")
    ///
    /// Not synchronized — mutating it after views are on screen is
    /// unsupported: rendered views won't refresh, and concurrent writes race.
    nonisolated(unsafe) public static var family: DSFontFamily?

    public static func largeTitle() -> Font { token(.largeTitle, weight: .bold) }
    public static func title() -> Font { token(.title, weight: .semibold) }
    public static func title2() -> Font { token(.title2, weight: .semibold) }
    public static func title3() -> Font { token(.title3, weight: .semibold) }
    public static func headline() -> Font { token(.headline) }
    public static func body() -> Font { token(.body) }
    public static func callout() -> Font { token(.callout) }
    public static func subheadline() -> Font { token(.subheadline) }
    public static func footnote() -> Font { token(.footnote) }
    public static func caption() -> Font { token(.caption) }
    public static func caption2() -> Font { token(.caption2) }

    /// Rounded display used by `DSResultCard` for highlighted results. A
    /// custom family replaces the rounded design.
    public static func resultPrimary() -> Font {
        token(.largeTitle, design: .rounded, weight: .bold)
    }

    public static func resultSecondary() -> Font {
        token(.title2, design: .rounded, weight: .semibold)
    }

    /// Massive display type for hero text taking up most of a screen —
    /// affirmations, mantras, single-word answers. Bypasses Dynamic Type
    /// scaling because the layout typically can't accommodate further
    /// growth; callers wanting Dynamic Type should use `largeTitle()`.
    public static func display(_ size: CGFloat = 44, weight: Font.Weight = .bold) -> Font {
        guard let family else {
            return .system(size: size, weight: weight, design: .default)
        }
        return Font.custom(family.name, fixedSize: size).weight(weight)
    }

    // MARK: - Private

    private static func token(
        _ style: Font.TextStyle,
        design: Font.Design = .default,
        weight: Font.Weight? = nil
    ) -> Font {
        guard let family else {
            let system = Font.system(style, design: design)
            return weight.map { system.weight($0) } ?? system
        }
        // `.headline` is semibold by system convention; mirror it so custom
        // families keep the same hierarchy without callers passing a weight.
        let effectiveWeight = weight ?? (style == .headline ? .semibold : nil)
        let custom = Font.custom(family.name, size: baseSize(style), relativeTo: style)
        return effectiveWeight.map { custom.weight($0) } ?? custom
    }

    /// Unscaled (default content size) point size of a text style, so a
    /// custom font scales with Dynamic Type exactly like its system
    /// counterpart via `Font.custom(_:size:relativeTo:)`.
    private static func baseSize(_ style: Font.TextStyle) -> CGFloat {
        let uiStyle: UIFont.TextStyle = switch style {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .subheadline: .subheadline
        case .body: .body
        case .callout: .callout
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        default: .body
        }
        return UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: uiStyle,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)
        ).pointSize
    }
}
