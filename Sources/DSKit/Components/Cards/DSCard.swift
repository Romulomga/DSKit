import SwiftUI

/// Surface variant for `DSCard`. Pick based on the surface beneath:
/// - `.default` over a plain background
/// - `.elevated` to lift off a busy background
/// - `.material` for floating surfaces (sheets, overlays)
public enum DSCardVariant: Sendable, Equatable {
    case `default`, elevated, material
}

/// Generic card container with Apple-like soft rounded corners.
public struct DSCard<Content: View>: View {
    private let variant: DSCardVariant
    private let content: Content

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
            .modifier(DSCardShadowModifier(variant: variant))
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .default: DSColor.surface
        case .elevated: DSColor.elevatedSurface
        case .material: Rectangle().fill(.regularMaterial)
        }
    }
}

private struct DSCardShadowModifier: ViewModifier {
    let variant: DSCardVariant

    func body(content: Content) -> some View {
        switch variant {
        case .elevated: content.dsShadow(.card)
        case .default, .material: content
        }
    }
}

#if DEBUG
#Preview("Card variants") {
    DSPreviewContainer("Card variants") {
        VStack(spacing: DSSpacing.md) {
            DSCard {
                Text("Default surface").font(DSTypography.body())
            }
            DSCard(.elevated) {
                Text("Elevated").font(DSTypography.body())
            }
            DSCard(.material) {
                Text("Material").font(DSTypography.body())
            }
        }
    }
}
#endif
