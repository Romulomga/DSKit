import Testing
@testable import DSKit

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
