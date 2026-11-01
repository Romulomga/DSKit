import Testing
import SwiftUI
@testable import DSKit

// Serialized: the suite mutates the shared `DSTypography.family`.
@Suite("Typography", .serialized)
struct TypographyTests {
    @Test func systemFontsByDefault() {
        DSTypography.family = nil
        #expect(DSTypography.body() == Font.system(.body, design: .default))
        #expect(DSTypography.title() == Font.system(.title, design: .default).weight(.semibold))
        #expect(DSTypography.headline() == Font.system(.headline, design: .default))
        #expect(DSTypography.resultPrimary() == Font.system(.largeTitle, design: .rounded).weight(.bold))
        #expect(DSTypography.display(40, weight: .heavy) == Font.system(size: 40, weight: .heavy, design: .default))
    }

    @Test func customFamilyDrivesEveryToken() {
        DSTypography.family = DSFontFamily("Avenir Next")
        defer { DSTypography.family = nil }
        #expect(DSTypography.body() == Font.custom("Avenir Next", size: 17, relativeTo: .body))
        #expect(DSTypography.title() == Font.custom("Avenir Next", size: 28, relativeTo: .title).weight(.semibold))
        // `.headline` keeps its semibold system convention under a custom family.
        #expect(DSTypography.headline() == Font.custom("Avenir Next", size: 17, relativeTo: .headline).weight(.semibold))
        // The rounded design is replaced by the family for display roles.
        #expect(DSTypography.resultPrimary() == Font.custom("Avenir Next", size: 34, relativeTo: .largeTitle).weight(.bold))
        // `display` stays fixed-size (no Dynamic Type) on the custom path too.
        #expect(DSTypography.display() == Font.custom("Avenir Next", fixedSize: 44).weight(.bold))
    }
}

@Suite("Tokens")
struct TokenTests {
    @Test func spacingScaleIsMonotonic() {
        let scale = [DSSpacing.xxs, DSSpacing.xs, DSSpacing.sm, DSSpacing.md,
                     DSSpacing.lg, DSSpacing.xl, DSSpacing.xxl]
        #expect(scale == scale.sorted())
        #expect(DSSpacing.xxs > 0)
    }

    @Test func radiusScaleIsMonotonic() {
        let scale = [DSRadius.sm, DSRadius.md, DSRadius.lg, DSRadius.xl]
        #expect(scale == scale.sorted())
        #expect(DSRadius.capsule >= DSRadius.xl)
    }
}

@Suite("Theme")
struct ThemeTests {
    @Test func defaultThemeHasAppName() {
        #expect(!DSTheme.default.appName.isEmpty)
    }

    @Test func accentFallsBackToPrimary() {
        let t = DSTheme(appName: "Pickr")
        #expect(t.accent == t.primary)
    }
}

@Suite("Accessibility helpers")
struct AccessibilityTests {
    @Test func combinedLabelSkipsEmpty() {
        let label = DSAccessibility.combinedLabel("Winner", nil, "   ", "Ana")
        #expect(label == "Winner, Ana")
    }

    @Test func combinedLabelJoinsWithComma() {
        let label = DSAccessibility.combinedLabel("Title", "Subtitle")
        #expect(label == "Title, Subtitle")
    }
}

@Suite("Surfaces")
struct SurfaceTests {
    @Test func canvasLevelUsesSurface() {
        #expect(Color.surface(level: 0) == Color.surface)
    }

    @Test func nestedLevelsUseElevatedSurface() {
        #expect(Color.surface(level: 1) == Color.surfaceElevated)
        #expect(Color.surface(level: 3) == Color.surfaceElevated)
    }

    @Test func surfaceLevelDefaultsToCanvas() {
        #expect(EnvironmentValues().dsSurfaceLevel == 0)
    }
}

@Suite("Package metadata")
struct MetadataTests {
    @Test func versionIsExposed() {
        #expect(!DSKit.version.isEmpty)
    }
}

@Suite("Fields")
struct FieldTests {
    @Test func versionMatchesTheReleasedTag() {
        #expect(DSKit.version == "1.0.41")
    }

    @Test func pickerOptionKeepsValueAsIdentity() {
        let option = DSPickerOption("RJ", label: "Rio de Janeiro")
        #expect(option.id == "RJ")
    }

    @Test func borderTellsTheState() {
        #expect(DSInputMetrics.borderWidth(isFocused: false, isInvalid: false) == 1)
        #expect(DSInputMetrics.borderWidth(isFocused: true, isInvalid: false) == 1.5)
        #expect(DSInputMetrics.borderWidth(isFocused: false, isInvalid: true) == 1.5)
        #expect(DSInputMetrics.borderColor(isFocused: true, isInvalid: true) == Color.errorHigh.opacity(0.7))
    }

    @Test func labelStyleDefaultsToCompact() {
        #expect(EnvironmentValues().dsFieldLabelStyle == .compact)
    }
}

@Suite("Overridable canvas and surface tokens")
struct OverridableTokenTests {
    @Test func overrideNamesArePrefixed() {
        // Prefixed, so a host app's own "Background"/"Surface" colorset never
        // restyles DSKit by accident.
        #expect(Color.overrideName(for: "Background") == "DSBackground")
        #expect(Color.overrideName(for: "BackgroundGrouped") == "DSBackgroundGrouped")
        #expect(Color.overrideName(for: "Surface") == "DSSurface")
        #expect(Color.overrideName(for: "SurfaceElevated") == "DSSurfaceElevated")
        #expect(Color.overrideName(for: "OnSurfaceHigh") == "DSOnSurfaceHigh")
        #expect(Color.overrideName(for: "Hairline") == "DSHairline")
    }

    @Test func withoutAHostColorTheTokenIsDSKitsOwn() {
        // The test host ships no `DS*` colorsets: nothing changes for apps
        // that don't opt in.
        #expect(Color.overridable("Surface") == Color("Surface", bundle: .module))
        #expect(Color.overridable("Background") == Color("Background", bundle: .module))
        #expect(Color.overridable("OnSurfaceMedium") == Color("OnSurfaceMedium", bundle: .module))
        #expect(Color.overridable("Border") == Color("Border", bundle: .module))
    }

    @Test func labelsOnPrimaryDefaultToOnAccent() {
        // A light primary needs a dark label: filled components read
        // `theme.onPrimary`, never a literal white.
        #expect(DSTheme().onPrimary == Color.onAccent)
        #expect(DSTheme(primary: .yellow, onPrimary: .black).onPrimary == .black)
    }

    @Test func proBadgeFollowsTheAccentUnlessTheHostOverridesIt() {
        // The test host ships no `DSProBadge`/`DSOnProBadge`: the badge keeps
        // the brand tint and the on-accent label.
        #expect(Color.hostOverride("ProBadge") == nil)
        #expect(Color.proBadge == Color.accentColor)
        #expect(Color.onProBadge == Color.onAccent)
    }
}
