import SwiftUI

/// Tinted button used for secondary actions like Share, Copy or Draw again.
public struct DSSecondaryButton: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

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
                Text(title).fontWeight(.medium)
            }
            .font(DSTypography.headline())
            .foregroundStyle(theme.primary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .padding(.horizontal, DSSpacing.lg)
            .background(theme.primary.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
            .opacity(isEnabled ? 1.0 : 0.5)
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
