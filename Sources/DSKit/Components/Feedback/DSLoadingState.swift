import SwiftUI

/// Centered `ProgressView` with an optional caption.
public struct DSLoadingState: View {
    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            ProgressView()
                .controlSize(.large)
            if let message {
                Text(message)
                    .font(DSTypography.subheadline())
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading")
    }
}

#if DEBUG
#Preview("Loading state") {
    DSPreviewContainer("Loading state") {
        DSLoadingState(message: "Drawing winner…")
    }
}
#endif
