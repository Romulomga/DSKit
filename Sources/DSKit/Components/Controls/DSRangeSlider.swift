import SwiftUI

/// Two-thumb slider over discrete steps `0...stepCount`. The caller owns the meaning
/// of each step (a price table, an area table) and renders it through `valueText`.
/// While dragging, the thumb follows the finger and ticks at every step it crosses;
/// on release it snaps to the nearest step. The thumbs never overlap and the range can
/// still narrow down to `minimumDistance` steps: each thumb rides its own lane, one
/// thumb-width apart (the lower one on `0...width - thumb`, the upper one on
/// `thumb...width`), so equal steps put them side by side.
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

    /// Length of each thumb's lane: the track minus the thumb-width that keeps them apart.
    private func laneWidth(_ width: CGFloat) -> CGFloat {
        max(width - Self.thumbSize, 0)
    }

    /// Where a thumb sits for a step: the upper lane starts one thumb-width in.
    private func position(of index: Int, for which: Thumb, in width: CGFloat) -> CGFloat {
        let fraction = CGFloat(min(max(index, 0), stepCount)) / CGFloat(stepCount)
        return fraction * laneWidth(width) + (which == .upper ? Self.thumbSize : 0)
    }

    private func index(atX x: CGFloat, for which: Thumb, in width: CGFloat) -> Int {
        let lane = laneWidth(width)
        guard lane > 0 else { return which == .lower ? 0 : stepCount }
        let laneX = x - (which == .upper ? Self.thumbSize : 0)
        return Int((laneX / lane * CGFloat(stepCount)).rounded())
    }

    /// The dragged thumb rides the finger, clamped to its lane and to the farthest step
    /// the other thumb allows.
    private func thumbX(_ which: Thumb, width: CGFloat) -> CGFloat {
        guard activeThumb == which, let dragX else {
            return position(of: which == .lower ? lowerIndex : upperIndex, for: which, in: width)
        }
        switch which {
        case .lower:
            let limit = position(of: max(upperIndex - minimumDistance, 0), for: .lower, in: width)
            return min(max(dragX, 0), limit)
        case .upper:
            let limit = position(of: min(lowerIndex + minimumDistance, stepCount), for: .upper, in: width)
            return max(min(dragX, width), limit)
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
                set(which, to: (which == .lower ? lowerIndex : upperIndex) + delta)
                onThumbMoved?(which)
            }
    }

    private func move(_ which: Thumb, toX x: CGFloat, width: CGFloat) {
        let target = index(atX: x, for: which, in: width)
        let current = which == .lower ? lowerIndex : upperIndex
        guard target != current else { return }
        let before = (lowerIndex, upperIndex)
        set(which, to: target)
        if before != (lowerIndex, upperIndex) {
            DSHaptics.light(if: hapticsEnabled)
        }
    }

    private func set(_ which: Thumb, to index: Int) {
        switch which {
        case .lower:
            lowerIndex = min(max(index, 0), max(upperIndex - minimumDistance, 0))
        case .upper:
            upperIndex = max(min(index, stepCount), min(lowerIndex + minimumDistance, stepCount))
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
