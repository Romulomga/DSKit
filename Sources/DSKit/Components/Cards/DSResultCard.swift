import SwiftUI

/// One grouped section inside `DSResultCard.grouped(...)`.
public struct DSResultSection: Sendable {
    public let title: String
    public let items: [String]

    public init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
}

/// Highlights a drawing/conversion result. Three shapes:
/// - `single` for one big answer
/// - `list` for ranked picks
/// - `grouped` for results split into named buckets
public struct DSResultCard: View {
    private enum Layout {
        case single(primary: String, subtitle: String?)
        case list(items: [String], subtitle: String?)
        case grouped(sections: [DSResultSection])
    }

    private let title: LocalizedStringKey
    private let layout: Layout

    /// Single highlighted result, e.g. the winner of a draw.
    public init(title: LocalizedStringKey, primaryResult: String, subtitle: String? = nil) {
        self.title = title
        self.layout = .single(primary: primaryResult, subtitle: subtitle)
    }

    /// Ordered list of results.
    public init(title: LocalizedStringKey, results: [String], subtitle: String? = nil) {
        self.title = title
        self.layout = .list(items: results, subtitle: subtitle)
    }

    /// Results split into named sections.
    public init(title: LocalizedStringKey, groupedResults: [DSResultSection]) {
        self.title = title
        self.layout = .grouped(sections: groupedResults)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(DSTypography.caption())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)

            switch layout {
            case let .single(primary, subtitle):
                singleView(primary: primary, subtitle: subtitle)
            case let .list(items, subtitle):
                listView(items: items, subtitle: subtitle)
            case let .grouped(sections):
                groupedView(sections: sections)
            }
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func singleView(primary: String, subtitle: String?) -> some View {
        Text(primary)
            .font(DSTypography.resultPrimary())
            .foregroundStyle(Color.onSurfaceHigh)
            .minimumScaleFactor(0.5)
            .lineLimit(2)
        if let subtitle {
            Text(subtitle)
                .font(DSTypography.subheadline())
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func listView(items: [String], subtitle: String?) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(spacing: DSSpacing.sm) {
                    Text("\(index + 1).")
                        .foregroundStyle(.secondary)
                    Text(item)
                        .foregroundStyle(Color.onSurfaceHigh)
                }
                .font(DSTypography.title3())
            }
        }
        if let subtitle {
            Text(subtitle)
                .font(DSTypography.footnote())
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func groupedView(sections: [DSResultSection]) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(section.title)
                        .font(DSTypography.footnote().weight(.semibold))
                        .foregroundStyle(.secondary)
                    ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                        Text(item)
                            .font(DSTypography.body())
                            .foregroundStyle(Color.onSurfaceHigh)
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview("Result card — single") {
    DSPreviewContainer("Single") {
        DSResultCard(
            title: "Winner",
            primaryResult: "Ana",
            subtitle: "Picked from 12 participants"
        )
    }
}

#Preview("Result card — list") {
    DSPreviewContainer("List") {
        DSResultCard(
            title: "Top 3",
            results: ["Ana", "Bruno", "Carla"],
            subtitle: "Out of 12 participants"
        )
    }
}

#Preview("Result card — grouped") {
    DSPreviewContainer("Grouped") {
        DSResultCard(
            title: "Teams",
            groupedResults: [
                DSResultSection(title: "Team A", items: ["Ana", "Bruno"]),
                DSResultSection(title: "Team B", items: ["Carla", "Diego"])
            ]
        )
    }
}
#endif
