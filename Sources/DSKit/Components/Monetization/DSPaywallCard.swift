import SwiftUI

/// Calm, non-aggressive Pro upgrade card. Lists features, exposes a primary
/// purchase button and a restore link. Wire the closures to your StoreKit
/// flow at the call site.
public struct DSPaywallCard: View {
    @Environment(\.dsTheme) private var theme

    private let title: LocalizedStringKey
    private let features: [LocalizedStringKey]
    private let priceText: LocalizedStringKey?
    private let purchaseTitle: LocalizedStringKey
    private let restoreTitle: LocalizedStringKey
    private let onPurchase: () -> Void
    private let onRestore: () -> Void

    public init(
        title: LocalizedStringKey = LocalizedStringKey(String(localized: "Upgrade to Pro", bundle: .dsKit)),
        features: [LocalizedStringKey],
        priceText: LocalizedStringKey? = nil,
        purchaseTitle: LocalizedStringKey = LocalizedStringKey(String(localized: "Continue", bundle: .dsKit)),
        restoreTitle: LocalizedStringKey = LocalizedStringKey(String(localized: "Restore purchases", bundle: .dsKit)),
        onPurchase: @escaping () -> Void,
        onRestore: @escaping () -> Void
    ) {
        self.title = title
        self.features = features
        self.priceText = priceText
        self.purchaseTitle = purchaseTitle
        self.restoreTitle = restoreTitle
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

            Button(action: onRestore) {
                Text(restoreTitle)
            }
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
