import SwiftUI

/// Two-thumb slider over discrete steps `0...stepCount`. The caller owns the
/// meaning of each step (a price table, an area table) and renders it through
/// `valueText`; the control keeps `lower < upper` by at least `minimumDistance`.
public struct DSRangeSlider: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let title: LocalizedStringKey?
    @Binding private var lowerIndex: Int
    @Binding private var upperIndex: Int
    private let stepCount: Int
    private let minimumDistance: Int
    private let valueText: LocalizedStringKey?
    private let onEditingChanged: ((Bool) -> Void)?
    private let onThumbMoved: ((Thumb) -> Void)?

    @State private var activeThumb: Thumb?

    public enum Thumb: Sendable {
        case lower
        case upper
    }

    private static let thumbSize: CGFloat = 28
    private static let trackHeight: CGFloat = 4

    public init(
        _ title: LocalizedStringKey? = nil,
        lowerIndex: Binding<Int>,
        upperIndex: Binding<Int>,
        stepCount: Int,
        minimumDistance: Int = 1,
        valueText: LocalizedStringKey? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onThumbMoved: ((Thumb) -> Void)? = nil
    ) {
        self.title = title
        self._lowerIndex = lowerIndex
        self._upperIndex = upperIndex
        self.stepCount = max(stepCount, 1)
        self.minimumDistance = max(minimumDistance, 0)
        self.valueText = valueText
        self.onEditingChanged = onEditingChanged
        self.onThumbMoved = onThumbMoved
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                let width = proxy.size.width
                let lowerX = position(of: lowerIndex, in: width)
                let upperX = position(of: upperIndex, in: width)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(theme.primary.opacity(0.16))
                        .frame(height: Self.trackHeight)

                    Capsule()
                        .fill(theme.primary)
                        .frame(width: max(upperX - lowerX, 0), height: Self.trackHeight)
                        .offset(x: lowerX)

                    thumb(.lower, at: lowerX, width: width)
                    thumb(.upper, at: upperX, width: width)
                }
                .frame(height: Self.thumbSize)
            }
            .frame(height: Self.thumbSize)
            .padding(.horizontal, Self.thumbSize / 2)

            if let valueText {
                Text(valueText)
                    .font(DSTypography.subheadline())
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
                    .animation(reduceMotion ? nil : DSMotion.short, value: lowerIndex)
                    .animation(reduceMotion ? nil : DSMotion.short, value: upperIndex)
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func position(of index: Int, in width: CGFloat) -> CGFloat {
        width * CGFloat(min(max(index, 0), stepCount)) / CGFloat(stepCount)
    }

    private func index(atX x: CGFloat, in width: CGFloat) -> Int {
        guard width > 0 else { return 0 }
        return Int((x / width * CGFloat(stepCount)).rounded())
    }

    private func thumb(_ which: Thumb, at x: CGFloat, width: CGFloat) -> some View {
        Circle()
            .fill(Color.white)
            .overlay(Circle().strokeBorder(theme.primary, lineWidth: 2))
            .shadow(color: .black.opacity(0.18), radius: 3, y: 1)
            .frame(width: Self.thumbSize, height: Self.thumbSize)
            .scaleEffect(activeThumb == which ? 1.12 : 1)
            .animation(reduceMotion ? nil : DSMotion.short, value: activeThumb)
            .offset(x: x - Self.thumbSize / 2)
            .zIndex(activeThumb == which ? 1 : 0)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if activeThumb == nil {
                            activeThumb = which
                            onEditingChanged?(true)
                        }
                        move(which, toX: value.location.x, width: width)
                    }
                    .onEnded { _ in
                        activeThumb = nil
                        onEditingChanged?(false)
                        onThumbMoved?(which)
                    }
            )
            .accessibilityElement()
            .accessibilityLabel(Text(which == .lower ? "Minimum" : "Maximum"))
            .accessibilityValue(Text("\(which == .lower ? lowerIndex : upperIndex) of \(stepCount)"))
            .accessibilityAdjustableAction { direction in
                let delta = direction == .increment ? 1 : -1
                set(which, to: (which == .lower ? lowerIndex : upperIndex) + delta)
                onThumbMoved?(which)
            }
    }

    private func move(_ which: Thumb, toX x: CGFloat, width: CGFloat) {
        let target = index(atX: x, in: width)
        let current = which == .lower ? lowerIndex : upperIndex
        guard target != current else { return }
        DSHaptics.light(if: hapticsEnabled)
        set(which, to: target)
    }

    private func set(_ which: Thumb, to index: Int) {
        switch which {
        case .lower:
            lowerIndex = min(max(index, 0), upperIndex - minimumDistance)
        case .upper:
            upperIndex = max(min(index, stepCount), lowerIndex + minimumDistance)
        }
    }
}

#if DEBUG
private struct DSRangeSliderPreviewHost: View {
    @State private var lower = 3
    @State private var upper = 9
    private let prices = [0, 90_000, 100_000, 120_000, 150_000, 200_000, 250_000, 300_000, 400_000, 500_000, 750_000, 1_000_000]

    var body: some View {
        DSRangeSlider(
            "Preço",
            lowerIndex: $lower,
            upperIndex: $upper,
            stepCount: prices.count - 1,
            valueText: "De R$ \(prices[lower]) até \(upper == prices.count - 1 ? "qualquer" : "R$ \(prices[upper])")"
        )
        .padding()
    }
}

#Preview {
    DSRangeSliderPreviewHost()
}
#endif
