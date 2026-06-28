import SwiftUI

/// Surface variant for `DSCard`. Pick based on the surface beneath:
/// - `.default` — standard card with a subtle border + soft shadow.
///   Always reads as a distinct surface against the scroll background.
/// - `.elevated` — stronger shadow for hero / featured cards.
/// - `.material` — translucent glass for floating overlays / action bars.
public enum DSCardVariant: Sendable, Equatable {
    case `default`, elevated, material
}

/// Generic card container with Apple-like soft rounded corners. The
/// `.default` variant ships with a subtle border and shadow so that cards
/// are never visually flush with the scroll background — even on systems
/// where `secondarySystemBackground` is very close to the canvas color.
public struct DSCard<Content: View>: View {
    private let variant: DSCardVariant
    private let content: Content

    @Environment(\.colorScheme) private var scheme

    public init(_ variant: DSCardVariant = .default, @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.content = content()
    }

    public var body: some View {
        content
            .padding(DSSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
            .overlay(border)
            .modifier(DSCardShadowModifier(variant: variant))
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .default:  Color.surface
        case .elevated: Color.surface
        case .material: Rectangle().fill(.regularMaterial)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .default, .elevated:
            RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous)
                .strokeBorder(borderStroke, lineWidth: 0.75)
        case .material:
            EmptyView()
        }
    }

    /// Light mode: a faint dark hairline. Dark mode: a faint *light* hairline — over a near-black
    /// canvas a dark border vanishes into the background (the "ghost edge"), so a top-lit light
    /// hairline is what makes the card read as a distinct surface (matching the system grouped-list
    /// look). A flat `Color.border` token can't satisfy both, hence the appearance switch.
    private var borderStroke: Color {
        scheme == .dark ? Color.white.opacity(0.10) : Color.border.opacity(0.5)
    }
}

private struct DSCardShadowModifier: ViewModifier {
    let variant: DSCardVariant

    func body(content: Content) -> some View {
        switch variant {
        case .default:  content.dsShadow(.subtle)
        case .elevated: content.dsShadow(.card)
        case .material: content
        }
    }
}

#if DEBUG
#Preview("Card variants") {
    DSPreviewContainer("Card variants") {
        VStack(spacing: DSSpacing.md) {
            DSCard {
                Text("Default — subtle border + soft shadow")
                    .font(DSTypography.body())
            }
            DSCard(.elevated) {
                Text("Elevated — stronger shadow")
                    .font(DSTypography.body())
            }
            DSCard(.material) {
                Text("Material — translucent")
                    .font(DSTypography.body())
            }
        }
    }
}
#endif
