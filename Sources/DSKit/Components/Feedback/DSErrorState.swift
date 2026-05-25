import SwiftUI

/// Full-screen error placeholder with an optional retry action.
public struct DSErrorState: View {
    private let systemImage: String
    private let title: String
    private let message: String
    private let retryTitle: String?
    private let onRetry: (() -> Void)?

    public init(
        systemImage: String = "exclamationmark.triangle",
        title: String,
        message: String,
        retryTitle: String? = "Try again",
        onRetry: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(DSColor.error)
            Text(title)
                .font(DSTypography.title3())
                .foregroundStyle(DSColor.textPrimary)
                .multilineTextAlignment(.center)
            Text(message)
                .font(DSTypography.subheadline())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DSSpacing.lg)
            if let onRetry, let retryTitle {
                DSSecondaryButton(retryTitle, systemImage: "arrow.clockwise", action: onRetry)
                    .padding(.top, DSSpacing.sm)
                    .padding(.horizontal, DSSpacing.lg)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(DSAccessibility.combinedLabel(title, message))
    }
}

#if DEBUG
#Preview("Error state") {
    DSPreviewContainer("Error state") {
        DSErrorState(
            title: "Couldn't load",
            message: "Check your connection and try again.",
            onRetry: {}
        )
    }
}
#endif
