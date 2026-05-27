import SwiftUI

/// Lightweight container used inside `#Preview` blocks to give components a
/// consistent grouped background and a small caption.
public struct DSPreviewContainer<Content: View>: View {
    private let title: String?
    private let content: Content

    public init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            if let title {
                Text(title)
                    .font(DSTypography.caption())
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            content
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background)
    }
}
