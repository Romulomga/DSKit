import SwiftUI

/// Selectable subscription/plan card used in paywalls. Shows a radio
/// indicator, title, price (monospaced for tabular alignment), period,
/// and an optional row of `DSBadge`s.
public struct DSPlanCard<Badges: View>: View {
    private let title: LocalizedStringKey
    private let price: LocalizedStringKey
    private let period: LocalizedStringKey
    private let isSelected: Bool
    private let action: () -> Void
    private let badges: Badges

    public init(
        title: LocalizedStringKey,
        price: LocalizedStringKey,
        period: LocalizedStringKey,
        isSelected: Bool,
        action: @escaping () -> Void,
        @ViewBuilder badges: () -> Badges = { EmptyView() }
    ) {
        self.title = title
        self.price = price
        self.period = period
        self.isSelected = isSelected
        self.action = action
        self.badges = badges()
    }

    public var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: DSSpacing.md) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? DSColor.primary : DSColor.textSecondary)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                    HStack(spacing: DSSpacing.xs) {
                        Text(title)
                            .font(DSTypography.headline())
                            .foregroundStyle(DSColor.textPrimary)
                        Spacer(minLength: 0)
                        Text(price)
                            .font(DSTypography.headline().monospacedDigit())
                            .foregroundStyle(DSColor.textPrimary)
                    }
                    HStack(spacing: DSSpacing.xs) {
                        Text(period)
                            .font(DSTypography.footnote())
                            .foregroundStyle(DSColor.textSecondary)
                        badges
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(DSSpacing.md)
            .background(DSColor.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                    .strokeBorder(
                        isSelected ? DSColor.primary.opacity(0.7) : DSColor.border.opacity(0.5),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }
}

#if DEBUG
private struct DSPlanCardPreviewHost: View {
    @State private var selected: String = "yearly"
    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            DSPlanCard(
                title: "Yearly",
                price: "R$ 34,90",
                period: "per year",
                isSelected: selected == "yearly",
                action: { selected = "yearly" }
            ) {
                DSBadge("7 days free", tint: DSColor.success)
                DSBadge("Save 70%", tint: DSColor.warning)
            }
            DSPlanCard(
                title: "Monthly",
                price: "R$ 9,90",
                period: "per month",
                isSelected: selected == "monthly",
                action: { selected = "monthly" }
            )
        }
    }
}

#Preview("Plan card") {
    DSPreviewContainer("Plan card") {
        DSPlanCardPreviewHost()
    }
}
#endif
