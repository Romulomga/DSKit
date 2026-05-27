import SwiftUI

/// Full-screen error placeholder with an optional retry action.
public struct DSErrorState: View {
    private let systemImage: String
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey
    private let retryTitle: LocalizedStringKey?
    private let onRetry: (() -> Void)?

    public init(
        systemImage: String = "exclamationmark.triangle",
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        retryTitle: LocalizedStringKey? = LocalizedStringKey(String(localized: "Try again", bundle: .dsKit)),
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
                .foregroundStyle(Color.errorHigh)
            Text(title)
                .font(DSTypography.title3())
                .foregroundStyle(Color.onSurfaceHigh)
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
