import SwiftUI

/// Settings-style toggle row. Use inside `DSSettingsSection` for the iOS
/// Settings look, or standalone for inline toggles.
public struct DSToggleRow: View {
    @Environment(\.dsTheme) private var theme

    private let title: LocalizedStringKey
    private let subtitle: LocalizedStringKey?
    private let systemImage: String?
    @Binding private var isOn: Bool

    public init(
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        systemImage: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self._isOn = isOn
    }

    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTypography.body())
                    .foregroundStyle(Color.onSurfaceHigh)
                if let subtitle {
                    Text(subtitle)
                        .font(DSTypography.footnote())
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.primary)
        }
        .padding(.vertical, DSSpacing.xs)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
private struct DSToggleRowPreviewHost: View {
    @State private var haptics = true
    @State private var sound = false

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSToggleRow("Haptics", subtitle: "Subtle vibration on actions",
                        systemImage: "iphone.radiowaves.left.and.right", isOn: $haptics)
            DSToggleRow("Sound", systemImage: "speaker.wave.2.fill", isOn: $sound)
        }
        .padding(DSSpacing.lg)
        .background(Color.surface)
    }
}

#Preview("Toggle row") {
    DSToggleRowPreviewHost()
}
#endif
