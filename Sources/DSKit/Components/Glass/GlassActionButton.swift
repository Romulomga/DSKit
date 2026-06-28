import SwiftUI

/// **Primary action** button, in glass. iOS 26: a **prominent** glass button, tinted with the brand
/// color — the "tint only on the primary action" rule (when everything is colored, nothing stands
/// out). iOS 17–18: falls back to `DSPrimaryButton` (a solid full-width fill). The split is
/// deliberate: on older iOS the solid is the right idiom; on iOS 26 a solid would **break** the
/// glass character.
///
/// Use only for a screen's dominant action (log, save, subscribe). Secondary actions stay in
/// `DSSecondaryButton`/`DSCard`.
@MainActor
public struct GlassActionButton: View {
    private let title: LocalizedStringKey
    private var systemImage: String?
    private var tint: Color
    /// Change this value (e.g. a counter bumped on **success**) to make the icon give a confirming
    /// *bounce* — "speed over spectacle". 0 = no feedback.
    private var feedback: Int
    private let action: () -> Void

    public init(_ title: LocalizedStringKey, systemImage: String? = nil, tint: Color = .accent, feedback: Int = 0, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.feedback = feedback
        self.action = action
    }

    public var body: some View {
        if #available(iOS 26.0, *) {
            Button {
                DSHaptics.light()
                action()
            } label: {
                HStack(spacing: DSSpacing.sm) {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .dsSymbolFeedback(feedback)
                    }

                    Text(title)
                        .fontWeight(.semibold)
                }
                .font(DSTypography.headline())
                .frame(maxWidth: .infinity)
                .frame(minHeight: 32)
                .padding(.vertical, DSSpacing.xs)
            }
            .buttonStyle(.glassProminent)
            .tint(tint)
            .controlSize(.large)
        } else {
            DSPrimaryButton(title, systemImage: systemImage, action: action)
        }
    }
}
