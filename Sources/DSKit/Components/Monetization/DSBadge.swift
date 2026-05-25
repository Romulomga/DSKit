import SwiftUI

/// Small tinted capsule used to flag short attributes ("7 days free",
/// "Save 70%", "New"). Pair with `DSProBadge` when the call-out is the
/// app-wide "PRO" marker.
public struct DSBadge: View {
    private let text: LocalizedStringKey
    private let tint: Color

    public init(_ text: LocalizedStringKey, tint: Color = DSColor.primary) {
        self.text = text
        self.tint = tint
    }

    public var body: some View {
        Text(text)
            .font(DSTypography.caption2().weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, DSSpacing.xs)
            .padding(.vertical, 2)
            .background(tint.opacity(0.14))
            .clipShape(Capsule())
    }
}

#if DEBUG
#Preview("Badge") {
    DSPreviewContainer("Badge") {
        HStack(spacing: DSSpacing.sm) {
            DSBadge("7 days free", tint: DSColor.success)
            DSBadge("Save 70%", tint: DSColor.warning)
            DSBadge("New")
        }
    }
}
#endif
