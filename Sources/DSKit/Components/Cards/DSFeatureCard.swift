import SwiftUI

/// Home-screen tile pointing to a feature/tool. Icon + title + description +
/// optional `Pro`/`New` badge or locked state.
public struct DSFeatureCard: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    private let title: LocalizedStringKey
    private let description: LocalizedStringKey
    private let systemImage: String
    private let badge: LocalizedStringKey?
    private let isLocked: Bool
    private let action: () -> Void

    public init(
        title: LocalizedStringKey,
        description: LocalizedStringKey,
        systemImage: String,
        badge: LocalizedStringKey? = nil,
        isLocked: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.badge = badge
        self.isLocked = isLocked
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.light(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(theme.primary)
                    .frame(width: 44, height: 44)
                    .background(theme.primary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))

                VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                    HStack(spacing: DSSpacing.xs) {
                        Text(title)
                            .font(DSTypography.headline())
                            .foregroundStyle(Color.onSurfaceHigh)
                        if let badge {
                            Text(badge)
                                .font(.caption2.weight(.bold))
                                .padding(.horizontal, DSSpacing.xs + 2)
                                .padding(.vertical, 2)
                                .background(theme.primary.opacity(0.15))
                                .foregroundStyle(theme.primary)
                                .clipShape(Capsule())
                        }
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    Text(description)
                        .font(DSTypography.subheadline())
                        .foregroundStyle(Color.onSurfaceMedium)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
            .padding(DSSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(isLocked ? Text("Locked") : Text(""))
    }
}

#if DEBUG
#Preview("Feature card") {
    DSPreviewContainer("Feature card") {
        VStack(spacing: DSSpacing.md) {
            DSFeatureCard(
                title: "Number Picker",
                description: "Pick random numbers from a range.",
                systemImage: "number"
            ) {}
            DSFeatureCard(
                title: "Name Picker",
                description: "Draw a winner from a list of names.",
                systemImage: "person.2.fill",
                badge: "NEW"
            ) {}
            DSFeatureCard(
                title: "Wheel",
                description: "Spin a roulette wheel.",
                systemImage: "circle.grid.cross.fill",
                badge: "PRO",
                isLocked: true
            ) {}
        }
    }
}
#endif
