import SwiftUI

/// Full-width pill-shaped CTA — radius equals half the height. Use in
/// onboarding flows, hero CTAs, or anywhere a softer, more inviting button
/// shape suits the content (wellness, mindfulness, lifestyle apps).
///
/// Two variants:
/// - `.primary` — filled accent, white text. Dominant action.
/// - `.secondary` — accent-tinted fill, accent text. Supporting action.
public struct DSPillButton: View {
    public enum Variant {
        case primary, secondary
    }

    @Environment(\.dsTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    private let title: LocalizedStringKey
    private let systemImage: String?
    private let variant: Variant
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: LocalizedStringKey,
        systemImage: String? = nil,
        variant: Variant = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.medium(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(foreground)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .font(DSTypography.headline())
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .padding(.horizontal, DSSpacing.lg)
            .background(background)
            .clipShape(Capsule())
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(isLoading || !isEnabled)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
    }

    private var foreground: Color {
        switch variant {
        case .primary:   return .white
        case .secondary: return theme.primary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            theme.primary
        case .secondary:
            theme.primary.opacity(0.12)
        }
    }
}

#if DEBUG
#Preview("Pill button") {
    DSPreviewContainer("Pill") {
        VStack(spacing: DSSpacing.md) {
            DSPillButton("Continuar") {}
            DSPillButton("Começar jornada", systemImage: "sparkles") {}
            DSPillButton("Loading", isLoading: true) {}
            DSPillButton("Secundário", variant: .secondary) {}
            DSPillButton("Disabled") {}
                .disabled(true)
        }
    }
}

#Preview("Pill button — dark") {
    DSPreviewContainer("Pill") {
        VStack(spacing: DSSpacing.md) {
            DSPillButton("Continuar") {}
            DSPillButton("Secundário", variant: .secondary) {}
        }
    }
    .preferredColorScheme(.dark)
}
#endif
