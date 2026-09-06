import SwiftUI

/// Full-width pill-shaped CTA — radius equals half the height. Use in
/// onboarding flows, hero CTAs, or anywhere a softer, more inviting button
/// shape suits the content (wellness, mindfulness, lifestyle apps).
///
/// Three variants:
/// - `.primary` — filled accent, white text. Dominant action.
/// - `.secondary` — accent-tinted fill, accent text. Supporting action.
/// - `.outlined` — transparent fill, accent stroke and text. Supporting
///   action over photography or `AtmosphericBackground`, where a tinted
///   wash would look muddy.
public struct DSPillButton: View {
    public enum Variant {
        case primary, secondary, outlined
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
            .overlay(outline)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(isLoading || !isEnabled)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
    }

    private var foreground: Color {
        switch variant {
        case .primary:              return .white
        case .secondary, .outlined: return theme.primary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            theme.primary
        case .secondary:
            theme.primary.opacity(0.12)
        case .outlined:
            Color.clear
        }
    }

    @ViewBuilder
    private var outline: some View {
        if variant == .outlined {
            Capsule().strokeBorder(theme.primary, lineWidth: 1.5)
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
            DSPillButton("Outlined", variant: .outlined) {}
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
            DSPillButton("Outlined", variant: .outlined) {}
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Pill button — atmospheric") {
    ZStack {
        AtmosphericBackground(tint: .accent)

        VStack(spacing: DSSpacing.md) {
            DSPillButton("Começar", systemImage: "sparkles") {}
            DSPillButton("Já tenho conta", variant: .outlined) {}
        }
        .padding(DSSpacing.lg)
    }
}
#endif
