import SwiftUI

/// Calm, non-aggressive Pro upgrade card. Lists features, exposes a primary
/// purchase button and a restore link. Wire the closures to your StoreKit
/// flow at the call site.
public struct DSPaywallCard: View {
    @Environment(\.dsTheme) private var theme

    private let title: String
    private let features: [String]
    private let priceText: String?
    private let purchaseTitle: String
    private let onPurchase: () -> Void
    private let onRestore: () -> Void

    public init(
        title: String = "Upgrade to Pro",
        features: [String],
        priceText: String? = nil,
        purchaseTitle: String = "Continue",
        onPurchase: @escaping () -> Void,
        onRestore: @escaping () -> Void
    ) {
        self.title = title
        self.features = features
        self.priceText = priceText
        self.purchaseTitle = purchaseTitle
        self.onPurchase = onPurchase
        self.onRestore = onRestore
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: "sparkles")
                    .foregroundStyle(theme.primary)
                Text(title)
                    .font(DSTypography.title3())
                    .foregroundStyle(DSColor.textPrimary)
                Spacer()
                DSProBadge()
            }

            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                    HStack(alignment: .firstTextBaseline, spacing: DSSpacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(theme.primary)
                        Text(feature)
                            .font(DSTypography.body())
                            .foregroundStyle(DSColor.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            if let priceText {
                Text(priceText)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
            }

            DSPrimaryButton(purchaseTitle, action: onPurchase)

            Button("Restore purchases", action: onRestore)
                .font(DSTypography.footnote())
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
    }
}

#if DEBUG
#Preview("Paywall card") {
    DSPreviewContainer("Paywall card") {
        DSPaywallCard(
            features: [
                "Unlimited draws",
                "Custom themes",
                "Export results",
                "No ads"
            ],
            priceText: "US$ 9.99 / year · cancel anytime",
            onPurchase: {},
            onRestore: {}
        )
    }
}
#endif
