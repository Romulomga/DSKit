import SwiftUI

/// Two-thumb slider over discrete steps `0...stepCount`. The caller owns the meaning
/// of each step (a price table, an area table) and renders it through `valueText`.
/// While dragging, the thumb follows the finger and ticks at every step it crosses;
/// on release it snaps to the nearest step. The thumbs never overlap: the moving one
/// stops one thumb-width away from the other (and never closer than `minimumDistance` steps).
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
    /// Where the finger is while a thumb is dragged; nil once it snapped.
    @State private var dragX: CGFloat?

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
                let lowerX = thumbX(.lower, width: width)
                let upperX = thumbX(.upper, width: width)

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
                .animation(reduceMotion || dragX != nil ? nil : DSMotion.snappy, value: lowerIndex)
                .animation(reduceMotion || dragX != nil ? nil : DSMotion.snappy, value: upperIndex)
                .animation(reduceMotion ? nil : DSMotion.snappy, value: dragX == nil)
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

    // MARK: - Geometry

    private func position(of index: Int, in width: CGFloat) -> CGFloat {
        width * CGFloat(min(max(index, 0), stepCount)) / CGFloat(stepCount)
    }

    private func index(atX x: CGFloat, in width: CGFloat) -> Int {
        guard width > 0 else { return 0 }
        return Int((x / width * CGFloat(stepCount)).rounded())
    }

    /// Steps the thumbs must keep between them so they never overlap on this width.
    private func gapSteps(in width: CGFloat) -> Int {
        guard width > 0 else { return minimumDistance }
        let stepWidth = width / CGFloat(stepCount)
        return max(minimumDistance, Int((Self.thumbSize / stepWidth).rounded(.up)))
    }

    /// The dragged thumb rides the finger, clamped to the track and to the other thumb.
    private func thumbX(_ which: Thumb, width: CGFloat) -> CGFloat {
        guard activeThumb == which, let dragX else {
            return position(of: which == .lower ? lowerIndex : upperIndex, in: width)
        }
        switch which {
        case .lower:
            let limit = position(of: upperIndex, in: width) - Self.thumbSize
            return min(max(dragX, 0), max(limit, 0))
        case .upper:
            let limit = position(of: lowerIndex, in: width) + Self.thumbSize
            return max(min(dragX, width), min(limit, width))
        }
    }

    // MARK: - Thumb

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
                        dragX = value.location.x
                        move(which, toX: value.location.x, width: width)
                    }
                    .onEnded { _ in
                        dragX = nil
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
                set(which, to: (which == .lower ? lowerIndex : upperIndex) + delta, gap: gapSteps(in: width))
                onThumbMoved?(which)
            }
    }

    private func move(_ which: Thumb, toX x: CGFloat, width: CGFloat) {
        let target = index(atX: x, in: width)
        let current = which == .lower ? lowerIndex : upperIndex
        guard target != current else { return }
        let before = (lowerIndex, upperIndex)
        set(which, to: target, gap: gapSteps(in: width))
        if before != (lowerIndex, upperIndex) {
            DSHaptics.light(if: hapticsEnabled)
        }
    }

    private func set(_ which: Thumb, to index: Int, gap: Int) {
        switch which {
        case .lower:
            lowerIndex = min(max(index, 0), max(upperIndex - gap, 0))
        case .upper:
            upperIndex = max(min(index, stepCount), min(lowerIndex + gap, stepCount))
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
