import SwiftUI

enum DSStepperLogic {
    /// Decimal places a floating-point step keeps, like `DSStepper` on Android.
    static let floatingPointPrecision = 10_000.0

    /// One step up or down, kept inside the range. A floating-point value is
    /// rounded first: 88.4 − 0.1 is 88.30000000000001 in binary, and that
    /// number, not the 88.3 on screen, is what the app would save.
    static func stepped<Value: AdditiveArithmetic & Comparable>(
        _ value: Value,
        by step: Value,
        in range: ClosedRange<Value>,
        increasing: Bool
    ) -> Value {
        let next = roundedIfFloatingPoint(increasing ? value + step : value - step)

        return min(max(next, range.lowerBound), range.upperBound)
    }

    private static func roundedIfFloatingPoint<Value>(_ value: Value) -> Value {
        guard let floating = value as? any BinaryFloatingPoint else { return value }

        return (rounded(floating) as? Value) ?? value
    }

    private static func rounded<F: BinaryFloatingPoint>(_ value: F) -> F {
        let precision = F(floatingPointPrecision)

        return (value * precision).rounded() / precision
    }
}

/// The native `Stepper` with a light haptic on every step. It keeps the
/// system behavior (clamps to the range, disables the side that reached the
/// limit) and only vibrates when the value really changes, so typing into a
/// field that shares the binding stays silent.
public struct DSStepper<Value: AdditiveArithmetic & Comparable, Label: View>: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    @Binding private var value: Value
    private let range: ClosedRange<Value>
    private let step: Value
    private let label: () -> Label

    public init(
        value: Binding<Value>,
        in range: ClosedRange<Value>,
        step: Value,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
    }

    public var body: some View {
        Stepper(
            onIncrement: value < range.upperBound ? { adjust(increasing: true) } : nil,
            onDecrement: value > range.lowerBound ? { adjust(increasing: false) } : nil,
            label: label
        )
    }

    private func adjust(increasing: Bool) {
        let next = DSStepperLogic.stepped(value, by: step, in: range, increasing: increasing)

        guard next != value else { return }

        value = next
        DSHaptics.light(if: hapticsEnabled)
    }
}

public extension DSStepper where Value: ExpressibleByIntegerLiteral {
    /// Step of 1, like the native `Stepper(value:in:)`.
    init(
        value: Binding<Value>,
        in range: ClosedRange<Value>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(value: value, in: range, step: 1, label: label)
    }
}

public extension DSStepper where Label == Text {
    init(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in range: ClosedRange<Value>,
        step: Value
    ) {
        self.init(value: value, in: range, step: step) {
            Text(title)
        }
    }
}

public extension DSStepper where Label == Text, Value: ExpressibleByIntegerLiteral {
    init(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in range: ClosedRange<Value>
    ) {
        self.init(title, value: value, in: range, step: 1)
    }
}

#if DEBUG
private struct DSStepperPreviewHost: View {
    @State private var installments = 3
    @State private var dose = 2.5

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            DSStepper(value: $installments, in: 1...12) {
                HStack {
                    Text("Installments")

                    Spacer()

                    Text(verbatim: "\(installments)x")
                        .monospacedDigit()
                }
            }

            DSStepper("Dose", value: $dose, in: 0.25...15, step: 0.25)
        }
        .font(DSTypography.body())
    }
}

#Preview("Stepper") {
    DSPreviewContainer("Stepper") {
        DSStepperPreviewHost()
    }
}
#endif
