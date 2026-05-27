import SwiftUI

/// Full-screen paged scroll, TikTok/Reels style. Each child page snaps to
/// the container's bounds — vertical by default, since the typical use is
/// "swipe up for next" (affirmations, prompts, daily cards).
///
/// Each page receives the full geometry so layouts can size to the screen
/// without manually measuring. The `pages` array is `Identifiable` so the
/// list can grow/shrink without breaking the scroll position.
public struct DSPagedScroll<Item: Identifiable, Page: View>: View {
    private let pages: [Item]
    private let axis: Axis
    private let showsIndicators: Bool
    @Binding private var currentID: Item.ID?
    private let page: (Item) -> Page

    public init(
        pages: [Item],
        axis: Axis = .vertical,
        showsIndicators: Bool = false,
        currentID: Binding<Item.ID?> = .constant(nil),
        @ViewBuilder page: @escaping (Item) -> Page
    ) {
        self.pages = pages
        self.axis = axis
        self.showsIndicators = showsIndicators
        self._currentID = currentID
        self.page = page
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollView(scrollAxes, showsIndicators: showsIndicators) {
                contentStack(in: proxy.size)
                    .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentID)
        }
    }

    private var scrollAxes: Axis.Set {
        axis == .vertical ? .vertical : .horizontal
    }

    @ViewBuilder
    private func contentStack(in size: CGSize) -> some View {
        if axis == .vertical {
            LazyVStack(spacing: 0) {
                ForEach(pages) { item in
                    page(item)
                        .frame(width: size.width, height: size.height)
                }
            }
        } else {
            LazyHStack(spacing: 0) {
                ForEach(pages) { item in
                    page(item)
                        .frame(width: size.width, height: size.height)
                }
            }
        }
    }
}

#if DEBUG
private struct DSPagedScrollPreviewHost: View {
    private struct Affirmation: Identifiable {
        let id = UUID()
        let text: String
    }

    private let pages: [Affirmation] = [
        .init(text: "Você não precisa amar cada momento pra ser uma boa mãe."),
        .init(text: "Pedir colo não é fraqueza — é coragem."),
        .init(text: "A mãe que ele precisa é a que você já é hoje."),
        .init(text: "É OK chorar trancada no banheiro às vezes.")
    ]

    @State private var currentID: UUID?

    var body: some View {
        DSPagedScroll(pages: pages, currentID: $currentID) { item in
            Text(item.text)
                .font(DSTypography.display(38))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.onSurfaceHigh)
                .padding(DSSpacing.lg)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
        }
    }
}

#Preview("PagedScroll — dark") {
    DSPagedScrollPreviewHost()
        .preferredColorScheme(.dark)
}
#endif
