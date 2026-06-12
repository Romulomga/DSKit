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

@Suite("Package metadata")
struct MetadataTests {
    @Test func versionIsExposed() {
        #expect(!DSKit.version.isEmpty)
    }
}
