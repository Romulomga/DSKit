import SwiftUI

/// Thin horizontal progress bar tinted with the theme primary. Designed for
/// onboarding step indicators and similar contexts where SwiftUI's default
/// `ProgressView` linear style is too thick or system-blue-leaking.
///
/// `value` is clamped to `0...1`. The fill animates smoothly when the value
/// changes — pass an explicit `animation: nil` if you want jump-cuts.
public struct DSProgressBar: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let value: Double
    private let height: CGFloat
    private let animation: Animation?

    public init(
        value: Double,
        height: CGFloat = 4,
        animation: Animation? = DSMotion.spring
    ) {
        self.value = value
        self.height = height
        self.animation = animation
    }

    public var body: some View {
        GeometryReader { proxy in
            let clamped = max(0, min(1, value))
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(theme.primary.opacity(0.16))
                Capsule()
                    .fill(theme.primary)
                    .frame(width: proxy.size.width * clamped)
                    .animation(reduceMotion ? nil : animation, value: clamped)
            }
        }
        .frame(height: height)
        .accessibilityElement()
        .accessibilityValue(Text("\(Int(value * 100))%"))
    }
}

#if DEBUG
private struct DSProgressBarPreviewHost: View {
    @State private var step = 3
    private let total = 8

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            DSProgressBar(value: Double(step) / Double(total))
            HStack {
                Text("Passo \(step) de \(total)")
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Avançar") { step = min(step + 1, total) }
            }
        }
        .padding(DSSpacing.lg)
        .background(Color.background)
    }
}

#Preview("Progress bar") { DSProgressBarPreviewHost() }
#Preview("Progress bar — dark") {
    DSProgressBarPreviewHost()
        .preferredColorScheme(.dark)
}
#endif
