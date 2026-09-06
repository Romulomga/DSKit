import SwiftUI

/// Selectable pill-shaped chip. Use in multi-select onboarding flows, tag
/// pickers, or anywhere a quick "tap-to-toggle" choice is needed.
///
/// Supports a leading emoji string OR an SF Symbol — pass only one. When
/// selected, the chip switches to an accent-tinted fill with a check glyph
/// on the trailing edge so screen readers and sighted users both have a
/// clear state signal.
public struct DSChip: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsSurfaceLevel) private var level

    private let title: LocalizedStringKey
    private let emoji: String?
    private let systemImage: String?
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        _ title: LocalizedStringKey,
        emoji: String? = nil,
        systemImage: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.emoji = emoji
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.light(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                leading
                Text(title)
                    .font(DSTypography.subheadline().weight(.semibold))
                    .foregroundStyle(isSelected ? theme.primary : Color.onSurfaceHigh)
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(theme.primary)
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                Capsule().fill(isSelected ? theme.primary.opacity(0.12) : Color.surface(level: level))
            )
            .overlay(
                Capsule().strokeBorder(
                    isSelected ? theme.primary : Color.clear,
                    lineWidth: 1.5
                )
            )
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var leading: some View {
        if let emoji {
            Text(emoji)
                .font(.system(size: 18))
        } else if let systemImage {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSelected ? theme.primary : Color.onSurfaceMedium)
        }
    }
}

#if DEBUG
private struct DSChipPreviewHost: View {
    @State private var selected: Set<String> = ["primeira-viagem", "trabalho"]

    private let options: [(id: String, label: LocalizedStringKey, emoji: String)] = [
        ("primeira-viagem", "Primeira viagem", "🌱"),
        ("pos-parto",       "Pós-parto recente", "💜"),
        ("atipica",         "Mãe atípica", "🌈"),
        ("solo",            "Mãe solo", "🦁"),
        ("trabalho",        "Voltando ao trabalho", "💼")
    ]

    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            ForEach(options, id: \.id) { option in
                DSChip(option.label, emoji: option.emoji, isSelected: selected.contains(option.id)) {
                    if selected.contains(option.id) {
                        selected.remove(option.id)
                    } else {
                        selected.insert(option.id)
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
        .background(Color.background)
    }
}

#Preview("Chip — light") { DSChipPreviewHost() }
#Preview("Chip — dark") {
    DSChipPreviewHost()
        .preferredColorScheme(.dark)
}
#endif
