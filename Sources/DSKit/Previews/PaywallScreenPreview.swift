#if DEBUG
import SwiftUI

struct PaywallScreenPreview: View {
    var body: some View {
        DSScreen(
            title: "Pro",
            subtitle: "Unlock everything in one tap"
        ) {
            DSPaywallCard(
                features: [
                    "Unlimited draws and history",
                    "Custom themes and app icons",
                    "Export to CSV and PDF",
                    "No ads, ever"
                ],
                priceText: "US$ 9.99 / year · cancel anytime",
                onPurchase: {},
                onRestore: {}
            )
        }
    }
}

#Preview("Paywall — light") {
    PaywallScreenPreview()
}

#Preview("Paywall — dark") {
    PaywallScreenPreview()
        .preferredColorScheme(.dark)
}
#endif
