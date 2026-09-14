import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Tabs whose pages swipe horizontally, one page per section, with the label strip on top.
/// A capsule indicator in the primary color follows the swipe (continuously on iOS 18, per
/// selection on iOS 17), the selected label gains weight and the primary color, VoiceOver
/// hears the tab it landed on. Up to three sections share the width equally; more scroll.
///
/// `header` sits between the strip and the pages (a search row, filters) and does not swipe.
/// The strip is either `.underline` (labels over a hairline, the indicator under the current
/// one) or `.segmented` (the pill of `DSSegmentedPicker(style: .filled)`, whose capsule
/// slides with the pages).
public struct DSPagedTabs<Section: Identifiable & Hashable, Header: View, Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sections: [Section]
    @Binding private var selection: Section.ID
    private let label: (Section) -> String
    private let style: DSPagedTabsStyle
    private let stripInset: CGFloat?
    private let header: () -> Header
    private let content: (Section) -> Content

    /// The page index as the pages move; the index of `selection` when they rest.
    @State private var progress: Double = 0
    @State private var scrollID: Section.ID?

    /// `stripInset`: horizontal margin of the strip; nil is the style's own (0 for `.underline`,
    /// `DSSpacing.lg` for `.segmented`).
    public init(
        sections: [Section],
        selection: Binding<Section.ID>,
        label: @escaping (Section) -> String,
        style: DSPagedTabsStyle = .underline,
        stripInset: CGFloat? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping (Section) -> Content
    ) {
        self.sections = sections
        self._selection = selection
        self.label = label
        self.style = style
        self.stripInset = stripInset
        self.header = header
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            switch style {
            case .underline:
                DSTabStrip(sections: sections, selection: $selection, progress: progress, label: label)
                    .padding(.horizontal, stripInset ?? 0)
            case .segmented:
                DSSegmentedTabStrip(sections: sections, selection: $selection, progress: progress, label: label)
                    .padding(.horizontal, stripInset ?? DSSpacing.lg)
                    .padding(.vertical, DSSpacing.sm)
            }

            header()

            pager
        }
        .onAppear {
            progress = index(of: selection)
            scrollID = selection
        }
        .onChange(of: selection) { _, newSelection in
            announce(newSelection)
            guard scrollID != newSelection else { return }
            if reduceMotion {
                scrollID = newSelection
            } else {
                withAnimation(DSMotion.medium) { scrollID = newSelection }
            }
        }
        .onChange(of: scrollID) { _, landed in
            guard let landed, landed != selection else { return }
            selection = landed
        }
    }

    private var pager: some View {
        ScrollView(.horizontal) {
            // Not lazy: every page exists, so a swipe never lands on an empty one.
            HStack(spacing: 0) {
                ForEach(sections) { section in
                    content(section)
                        .containerRelativeFrame(.horizontal)
                        .frame(maxHeight: .infinity)
                        .accessibilityHidden(section.id != selection)
                        .id(section.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
        .scrollIndicators(.hidden)
        .modifier(DSPagerProgress(progress: $progress, pageCount: sections.count, resting: index(of: selection)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func index(of id: Section.ID) -> Double {
        Double(sections.firstIndex { $0.id == id } ?? 0)
    }

    private func announce(_ id: Section.ID) {
        #if canImport(UIKit)
        guard let section = sections.first(where: { $0.id == id }) else { return }
        UIAccessibility.post(notification: .announcement, argument: label(section))
        #endif
    }
}

public extension DSPagedTabs where Header == EmptyView {
    init(
        sections: [Section],
        selection: Binding<Section.ID>,
        label: @escaping (Section) -> String,
        style: DSPagedTabsStyle = .underline,
        stripInset: CGFloat? = nil,
        @ViewBuilder content: @escaping (Section) -> Content
    ) {
        self.init(
            sections: sections, selection: selection, label: label, style: style, stripInset: stripInset, header: { EmptyView() }, content: content
        )
    }
}

/// How the strip of a `DSPagedTabs` is drawn.
public enum DSPagedTabsStyle: Sendable {
    /// Labels over a hairline, a capsule indicator under the current one.
    case underline
    /// The pill of `DSSegmentedPicker(style: .filled)`: the primary capsule slides with the pages.
    case segmented
}

/// The segmented strip: equal-width labels on a `surface` track with a hairline, the primary
/// capsule positioned by `progress` (so it follows the swipe), white label on it.
struct DSSegmentedTabStrip<Section: Identifiable & Hashable>: View {
    @Environment(\.dsTheme) private var theme

    let sections: [Section]
    @Binding var selection: Section.ID
    let progress: Double
    let label: (Section) -> String

    @State private var trackWidth: CGFloat = 0

    private static var height: CGFloat { 36 }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                tab(section, index: index)
            }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { trackWidth = $0 }
        // As a background the capsule takes the labels' height; as a sibling in a ZStack the
        // shape had no height of its own and grew to share the screen with the pages.
        .background(alignment: .leading) {
            if trackWidth > 0, !sections.isEmpty {
                Capsule()
                    .fill(theme.primary)
                    .frame(width: tabWidth)
                    .offset(x: CGFloat(min(max(progress, 0), Double(sections.count - 1))) * tabWidth)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
        }
        .padding(DSSpacing.xxs)
        .background(Color.surface, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.hairline, lineWidth: 1))
        .accessibilityElement(children: .contain)
    }

    private var tabWidth: CGFloat { trackWidth / CGFloat(max(sections.count, 1)) }

    private func tab(_ section: Section, index: Int) -> some View {
        let isCurrent = abs(progress - Double(index)) < 0.5

        return Button {
            selection = section.id
        } label: {
            Text(label(section))
                .font(DSTypography.footnote().weight(.semibold))
                .foregroundStyle(isCurrent ? Color.white : Color.onSurfaceMedium)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, DSSpacing.sm)
                .frame(maxWidth: .infinity, minHeight: Self.height)
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == section.id ? .isSelected : [])
        .accessibilityValue(Text("\(index + 1)/\(sections.count)"))
    }
}

/// The page index the pager is at, as a continuous value. iOS 18 reads the scroll offset;
/// iOS 17 has no offset feed, so the value moves to the resting page with an animation.
private struct DSPagerProgress: ViewModifier {
    @Binding var progress: Double
    let pageCount: Int
    let resting: Double

    func body(content: Content) -> some View {
        if #available(iOS 18, *) {
            content.onScrollGeometryChange(for: Double.self) { geometry in
                geometry.containerSize.width > 0 ? geometry.contentOffset.x / geometry.containerSize.width : 0
            } action: { _, value in
                progress = min(max(value, 0), Double(max(pageCount - 1, 0)))
            }
        } else {
            content.onChange(of: resting, initial: true) { _, value in
                withAnimation(DSMotion.medium) { progress = value }
            }
        }
    }
}

/// The label strip: one button per section, the indicator interpolated between the label
/// centers and widths of the two nearest sections.
struct DSTabStrip<Section: Identifiable & Hashable>: View {
    @Environment(\.dsTheme) private var theme

    let sections: [Section]
    @Binding var selection: Section.ID
    let progress: Double
    let label: (Section) -> String

    @State private var tabFrames: [Section.ID: CGRect] = [:]
    @State private var labelWidths: [Section.ID: CGFloat] = [:]

    private static var space: String { "DSTabStrip" }
    private static var indicatorHeight: CGFloat { 3 }

    var body: some View {
        Group {
            if sections.count > 3 {
                ScrollView(.horizontal, showsIndicators: false) {
                    strip(fill: false)
                }
            } else {
                strip(fill: true)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.hairline)
                .frame(height: 1)
        }
        .accessibilityElement(children: .contain)
    }

    private func strip(fill: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            HStack(spacing: 0) {
                ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                    tab(section, index: index)
                        .frame(maxWidth: fill ? .infinity : nil)
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(Self.space)) } action: { tabFrames[section.id] = $0 }
                }
            }

            indicator
        }
        .coordinateSpace(name: Self.space)
    }

    private func tab(_ section: Section, index: Int) -> some View {
        let activeness = max(0, 1 - abs(progress - Double(index)))
        let isCurrent = activeness > 0.5

        return Button {
            selection = section.id
        } label: {
            Text(label(section))
                .font(isCurrent ? DSTypography.subheadline().weight(.semibold) : DSTypography.subheadline())
                .foregroundStyle(isCurrent ? theme.primary : Color.onSurfaceMedium)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { labelWidths[section.id] = $0 }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
                .frame(maxWidth: .infinity, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == section.id ? .isSelected : [])
        .accessibilityValue(Text("\(index + 1)/\(sections.count)"))
    }

    @ViewBuilder private var indicator: some View {
        if let geometry = indicatorGeometry {
            Capsule()
                .fill(theme.primary)
                .frame(width: geometry.width, height: Self.indicatorHeight)
                .offset(x: geometry.minX)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }

    /// Center and width between the two sections nearest to `progress`.
    private var indicatorGeometry: (minX: CGFloat, width: CGFloat)? {
        guard !sections.isEmpty else { return nil }
        let clamped = min(max(progress, 0), Double(sections.count - 1))
        let lower = Int(clamped.rounded(.down))
        let upper = min(lower + 1, sections.count - 1)
        let fraction = CGFloat(clamped - Double(lower))
        guard let lowerFrame = tabFrames[sections[lower].id], let upperFrame = tabFrames[sections[upper].id] else { return nil }
        let lowerWidth = labelWidths[sections[lower].id] ?? lowerFrame.width / 2
        let upperWidth = labelWidths[sections[upper].id] ?? upperFrame.width / 2
        let width = lowerWidth + (upperWidth - lowerWidth) * fraction
        let centerX = lowerFrame.midX + (upperFrame.midX - lowerFrame.midX) * fraction
        return (centerX - width / 2, width)
    }
}

#if DEBUG
private struct DSPagedTabsPreviewHost: View {
    struct Page: Identifiable, Hashable {
        let id: String
        let title: String
    }

    @State private var selection = "active"

    private let pages = [Page(id: "active", title: "4 Active items"), Page(id: "inactive", title: "1 Inactive item")]

    var body: some View {
        DSPagedTabs(sections: pages, selection: $selection, label: \.title, style: .segmented) {
            Text("Header between the strip and the pages")
                .font(DSTypography.footnote())
                .padding(DSSpacing.md)
        } content: { page in
            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    ForEach(0..<8, id: \.self) { row in
                        DSCard { Text("\(page.title) · row \(row + 1)") }
                    }
                }
                .padding(DSSpacing.md)
            }
        }
    }
}

#Preview("Paged tabs") {
    DSPreviewContainer("Paged tabs") {
        DSPagedTabsPreviewHost()
    }
}
#endif
