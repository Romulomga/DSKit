import SwiftUI

/// Wraps `LazyVGrid` with an adaptive column count derived from a minimum
/// item width — items grow on iPad/landscape without you computing breakpoints.
public struct DSAdaptiveGrid<Content: View>: View {
    private let minItemWidth: CGFloat
    private let spacing: CGFloat
    private let content: Content

    public init(
        minItemWidth: CGFloat = 160,
        spacing: CGFloat = DSSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: minItemWidth), spacing: spacing)],
            spacing: spacing
        ) {
            content
        }
    }
}

#if DEBUG
#Preview("Adaptive grid") {
    DSPreviewContainer("Adaptive grid") {
        DSAdaptiveGrid {
            ForEach(0..<6) { i in
                DSCard {
                    Text("Item \(i + 1)").font(DSTypography.headline())
                }
            }
        }
    }
}
#endif
