import SwiftUI

/// Reusable screen container — grouped background, scrollable content, large
/// title header, optional trailing toolbar and optional bottom action area.
///
/// Example:
/// ```swift
/// DSScreen(title: "Name Picker", subtitle: "Add names and pick a winner") {
///     DSListInput(text: $text)
/// } bottomAction: {
///     DSPrimaryButton("Pick winner") { ... }
/// }
/// ```
public struct DSScreen<Content: View>: View {
    private let title: LocalizedStringKey?
    private let subtitle: LocalizedStringKey?
    private let trailing: AnyView?
    private let bottomAction: AnyView?
    private let content: Content

    public init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = nil
        self.bottomAction = nil
        self.content = content()
    }

    public init<Trailing: View>(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(trailing())
        self.bottomAction = nil
        self.content = content()
    }

    public init<BottomAction: View>(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomAction: () -> BottomAction
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = nil
        self.bottomAction = AnyView(bottomAction())
        self.content = content()
    }

    public init<Trailing: View, BottomAction: View>(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomAction: () -> BottomAction
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(trailing())
        self.bottomAction = AnyView(bottomAction())
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                if title != nil || subtitle != nil || trailing != nil {
                    header
                }
                content
            }
            .padding(.horizontal, DSSpacing.lg)
            .padding(.top, DSSpacing.md)
            .padding(.bottom, DSSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(DSColor.groupedBackground.ignoresSafeArea())
        // `safeAreaInset` lets the bottom action ride above the keyboard so
        // the toolbar accessory never overlaps the primary CTA, and pads the
        // scroll content automatically so cards above it stay reachable.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if let bottomAction {
                bottomAction
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.top, DSSpacing.md)
                    .padding(.bottom, DSSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [
                                DSColor.groupedBackground.opacity(0),
                                DSColor.groupedBackground,
                                DSColor.groupedBackground
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
    }

    @ViewBuilder
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                if let title {
                    Text(title)
                        .font(DSTypography.largeTitle())
                        .foregroundStyle(DSColor.textPrimary)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(DSTypography.subheadline())
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let trailing {
                trailing
            }
        }
    }
}

#if DEBUG
#Preview("Screen") {
    DSScreen(title: "Name Picker", subtitle: "Add names and pick a winner") {
        DSCard {
            Text("Content goes here").font(DSTypography.body())
        }
    } bottomAction: {
        DSPrimaryButton("Pick winner", systemImage: "sparkles") {}
    }
}
#endif
