import SwiftUI

/// "Nothing here yet" view. Centered icon + title + message + optional CTA.
public struct DSEmptyState: View {
    private let systemImage: String
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey
    private let actionTitle: LocalizedStringKey?
    private let action: (() -> Void)?

    public init(
        systemImage: String,
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        actionTitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.tertiary)
            Text(title)
                .font(DSTypography.title3())
                .foregroundStyle(Color.onSurfaceHigh)
                .multilineTextAlignment(.center)
            Text(message)
                .font(DSTypography.subheadline())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DSSpacing.lg)
            if let actionTitle, let action {
                DSPrimaryButton(actionTitle, action: action)
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
#Preview("Empty state") {
    DSPreviewContainer("Empty state") {
        DSEmptyState(
            systemImage: "person.2",
            title: "No participants yet",
            message: "Add at least two names to draw a winner.",
            actionTitle: "Add names"
        ) {}
    }
}
#endif
