import SwiftUI

/// "Nothing here yet" view. Centered icon + title + message + optional CTA.
///
/// The icon is an SF Symbol (56pt, tertiary) or the app's own illustration (`illustration:`), shown in its own
/// colors at up to 120pt tall and scaled down with Dynamic Type's accessibility sizes, so the text keeps the room.
public struct DSEmptyState: View {
    private enum Artwork {
        case symbol(String)
        case illustration(Image)
    }

    private let artwork: Artwork
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
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
        self.artwork = .symbol(systemImage)
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    /// With the app's own illustration (an asset, not a template): decorative, VoiceOver reads the title and message.
    public init(
        illustration: Image,
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        actionTitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        self.artwork = .illustration(illustration)
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            artworkView

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

    @ViewBuilder
    private var artworkView: some View {
        switch artwork {
        case .symbol(let name):
            Image(systemName: name)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.tertiary)

        case .illustration(let image):
            image
                .resizable()
                .scaledToFit()
                .frame(height: dynamicTypeSize.isAccessibilitySize ? Self.compactIllustrationHeight : Self.illustrationHeight)
                .accessibilityHidden(true)
        }
    }

    static let illustrationHeight: CGFloat = 120
    static let compactIllustrationHeight: CGFloat = 80
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

        DSEmptyState(
            illustration: Image(systemName: "photo.artframe"),
            title: "Nothing in the album",
            message: "An app's own illustration sits here, in its own colors."
        )
    }
}
#endif
