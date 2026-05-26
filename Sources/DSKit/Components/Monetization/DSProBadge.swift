import SwiftUI

/// Small "PRO" pill used to flag premium features in lists or headers.
public struct DSProBadge: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey = LocalizedStringKey(String(localized: "PRO", bundle: .dsKit))) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, DSSpacing.xs + 2)
            .padding(.vertical, 2)
            .foregroundStyle(.white)
            .background(
                // `Color.accentColor` mirrors the environment `.tint(_:)`,
                // so the badge follows the brand color across the app
                // instead of falling back to system blue.
                LinearGradient(
                    colors: [Color.accentColor, Color.accentColor.opacity(0.78)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
    }
}

#if DEBUG
#Preview("Pro badge") {
    DSPreviewContainer("Pro badge") {
        HStack(spacing: DSSpacing.sm) {
            DSProBadge()
            DSProBadge("NEW")
            DSProBadge("BETA")
        }
    }
}
#endif
