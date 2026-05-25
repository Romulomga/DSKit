# DSKit

SwiftUI design system for small Apple-native utility apps (number pickers, name pickers, converters, timers, etc).

The goal is **not** a heavily branded look — it's a clean, calm, native-feeling experience built on Apple's own design language (Settings, Shortcuts, Reminders, Fitness). One package, many small apps, consistent feel.

- **Platform:** iOS 17+
- **Frameworks:** SwiftUI only (UIKit for haptics & pasteboard)
- **Dependencies:** none

## Installation

Add the package via Xcode → File → Add Packages → paste the repository URL, or in your `Package.swift`:

```swift
.package(path: "../DSKit")
```

Then add the product as a dependency on your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "DSKit", package: "DSKit")
    ]
)
```

## Basic usage

```swift
import SwiftUI
import DSKit

struct ContentView: View {
    @State private var names = ""

    var body: some View {
        DSScreen(title: "Name Picker", subtitle: "Add names and pick a winner") {
            DSListInput(title: "Participants", text: $names)
        } bottomAction: {
            DSPrimaryButton("Pick winner", systemImage: "sparkles") {
                // your draw logic
            }
        }
    }
}
```

## Theming

`DSTheme` lets each app override the primary tint and display name without
touching the rest of the design language.

```swift
@main
struct PickrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .microToolsTheme(
                    DSTheme(appName: "Pickr", primary: .orange)
                )
        }
    }
}
```

The modifier injects the theme into the SwiftUI environment **and** sets
`.tint(theme.primary)` so native controls (Toggle, Picker, NavigationLink)
inherit the same color.

## Component map

| Group          | Components |
| -------------- | ---------- |
| Tokens         | `DSSpacing`, `DSRadius`, `DSColor`, `DSTypography`, `DSShadow`, `DSMotion` |
| Theme          | `DSTheme`, `EnvironmentValues.dsTheme`, `.microToolsTheme(_:)` |
| Buttons        | `DSPrimaryButton`, `DSSecondaryButton`, `DSDestructiveButton`, `DSIconButton` |
| Cards          | `DSCard`, `DSFeatureCard`, `DSResultCard` |
| Inputs         | `DSTextField`, `DSNumberField`, `DSListInput` |
| Feedback       | `DSEmptyState`, `DSErrorState`, `DSLoadingState`, `DSToast` |
| Layout         | `DSScreen`, `DSSection`, `DSSettingsSection` (+ `DSSettingsRow`), `DSAdaptiveGrid` |
| Controls       | `DSToggleRow`, `DSOptionChip`, `DSSegmentedPicker` |
| Monetization   | `DSPaywallCard`, `DSProBadge` |
| Utilities      | `DSHaptics`, `DSAccessibility`, `DSPreviewContainer` |

Every component has at least one SwiftUI preview. Composite screen previews live in `Sources/DSKit/Previews/`:

- `RandomPickerHomePreview`
- `NumberPickerScreenPreview`
- `NamePickerScreenPreview`
- `ResultScreenPreview`
- `SettingsScreenPreview`
- `PaywallScreenPreview`

Open any file in Xcode and the canvas will pick them up.

## Design principles

1. **Look like Apple, not like a brand.** Semantic system colors, system fonts, system materials. Themes only override tint and app name.
2. **Respect the user.** Dynamic Type scales every text style; Reduce Motion suppresses press scale; VoiceOver gets combined labels on cards.
3. **One primary action per screen.** `DSPrimaryButton` is bold; secondary actions are tinted; destructive actions are explicit and red.
4. **Soft surfaces.** `DSColor.surface` / `DSColor.elevatedSurface` over `DSColor.groupedBackground`. Shadows are extremely subtle and reserved for `DSCard(.elevated)` and floating overlays.
5. **No fixed heights that break accessibility.** Buttons use `minHeight` rather than `frame(height:)`. Result text uses `minimumScaleFactor`.
6. **Haptics are the punctuation.** Every interactive component nudges with `DSHaptics.light()` / `.medium()` — toggle off at call site if needed by using primitive SwiftUI controls.
7. **UI-only.** Logic for random draws, parsing or storage lives in the app, not in the package. `DSListInput` exposes `lines`/`itemCount`/`duplicateCount` as conveniences, nothing more.

## Architecture

- `Tokens/` — primitive constants (spacing, radius, color, typography, shadow, motion). No views, no state.
- `Theme/` — `DSTheme` struct + `EnvironmentKey` + `.microToolsTheme(_:)` view modifier.
- `Components/` — grouped by intent (Buttons, Cards, Inputs, Feedback, Layout, Controls, Monetization, Utilities). Each file is one public type plus a `#if DEBUG` `#Preview`.
- `Previews/` — `#if DEBUG` composite previews showing real screen compositions for the canonical utility-app archetypes.
- `DSKit.swift` — umbrella with package metadata only.

Public types use the `DS` prefix to avoid collisions when the package is mixed with other code. Internal helpers (e.g. `DSPressableButtonStyle`) are kept non-public on purpose.

## Building

This is an iOS-only package (`UIKit` for haptics + pasteboard, iOS-only SwiftUI APIs like `.keyboardType`, `Color(uiColor:)`). Build through Xcode's iOS toolchain:

```sh
xcodebuild -scheme DSKit -destination 'generic/platform=iOS' build
xcodebuild test -scheme DSKit -destination 'platform=iOS Simulator,name=iPhone 17'
```

`swift build` from the command line targets the host (macOS) and will fail on the UIKit import — that's expected. Open `Package.swift` in Xcode for a normal SPM workflow.
