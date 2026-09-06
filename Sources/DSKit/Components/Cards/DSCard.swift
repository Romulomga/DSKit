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

    @Environment(\.dsSurfaceLevel) private var level

    public init(_ variant: DSCardVariant = .default, @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.content = content()
    }

    public var body: some View {
        content
            .dsSurfaceContainer()
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
        case .default:  Color.surface(level: level)
        case .elevated: Color.surface(level: level)
        case .material: Rectangle().fill(.regularMaterial)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .default, .elevated:
            RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous)
                .strokeBorder(Color.hairline, lineWidth: 0.75)
        case .material:
            EmptyView()
        }
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

private struct DSCardNestedPreviewHost: View {
    @State private var name = ""

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Nested input reads on surfaceElevated")
                    .font(DSTypography.headline())

                DSTextField(title: "Name", placeholder: "Your name", text: $name)
            }
        }
    }
}

#Preview("Card — nested input") {
    DSPreviewContainer("Nested") {
        DSCardNestedPreviewHost()
    }
}

#Preview("Card — grouped canvas") {
    ScrollView {
        VStack(spacing: DSSpacing.md) {
            DSCard {
                Text("Elevated cell on grouped canvas")
                    .font(DSTypography.body())
            }

            DSCard {
                Text("iOS Settings look")
                    .font(DSTypography.body())
            }
        }
        .padding(DSSpacing.lg)
    }
    .dsGroupedCanvas()
}

#Preview("Card — grouped canvas dark") {
    ScrollView {
        DSCard {
            Text("Elevated cell on grouped canvas")
                .font(DSTypography.body())
        }
        .padding(DSSpacing.lg)
    }
    .dsGroupedCanvas()
    .preferredColorScheme(.dark)
}
#endif
