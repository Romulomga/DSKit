import SwiftUI

/// Destructive action button — uses `systemRed`. Pair with a confirmation
/// dialog at the call site.
public struct DSDestructiveButton: View {
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
        Button(role: .destructive) {
            DSHaptics.warning(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title).fontWeight(.medium)
            }
            .font(DSTypography.headline())
            .foregroundStyle(Color.errorHigh)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .padding(.horizontal, DSSpacing.lg)
            .background(Color.errorHigh.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(title)
    }
}

#if DEBUG
#Preview("Destructive") {
    DSPreviewContainer("Destructive") {
        DSDestructiveButton("Clear list", systemImage: "trash") {}
    }
}
#endif
