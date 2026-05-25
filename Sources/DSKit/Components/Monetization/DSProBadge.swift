import SwiftUI

/// Small "PRO" pill used to flag premium features in lists or headers.
public struct DSProBadge: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey = "PRO") {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, DSSpacing.xs + 2)
            .padding(.vertical, 2)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [Color(uiColor: .systemBlue), Color(uiColor: .systemIndigo)],
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
