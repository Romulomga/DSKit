import SwiftUI

/// A titled vertical stack — group related content under a single headline.
public struct DSSection<Content: View>: View {
    private let title: String?
    private let content: Content

    public init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            if let title {
                Text(title)
                    .font(DSTypography.headline())
                    .foregroundStyle(DSColor.textPrimary)
            }
            content
        }
    }
}

#if DEBUG
#Preview("Section") {
    DSPreviewContainer("Section") {
        DSSection("Recent") {
            DSCard { Text("Item 1") }
            DSCard { Text("Item 2") }
        }
    }
}
#endif
