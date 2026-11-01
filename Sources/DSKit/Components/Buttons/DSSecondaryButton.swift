import SwiftUI

/// Tinted button used for secondary actions like Share, Copy or Draw again.
public struct DSSecondaryButton: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    /// Grows with Dynamic Type, like `DSPrimaryButton`.
    @ScaledMetric(relativeTo: .headline) private var verticalPadding = DSSpacing.md

    private let title: LocalizedStringKey
    private let systemImage: String?
    private let action: () -> Void

    public init(
        _ title: LocalizedStringKey,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.light(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            .font(DSTypography.headline())
            .foregroundStyle(isEnabled ? theme.primary : Color.onDisabledFill)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .padding(.horizontal, DSSpacing.lg)
            .background(isEnabled ? theme.primary.opacity(0.12) : Color.disabledFill)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(title)
    }
}

#if DEBUG
#Preview("Secondary") {
    DSPreviewContainer("Secondary") {
        VStack(spacing: DSSpacing.md) {
            DSSecondaryButton("Share", systemImage: "square.and.arrow.up") {}
            DSSecondaryButton("Draw again") {}
        }
    }
}
#endif
