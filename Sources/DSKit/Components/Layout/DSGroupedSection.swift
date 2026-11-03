import SwiftUI

/// A group of rows on one rounded surface — what an inset-grouped `List`
/// section draws, with DSKit's own corner (`DSRadius.lg`, the same as `DSCard`),
/// so lists, forms and cards read as one family. iOS 26 lists draw a much
/// larger corner that no token reaches, and clip any custom surface inside a
/// row to it.
///
/// The title reads like `DSSection`'s (headline, high emphasis); the footer is
/// a footnote under the group. Rows stack with no spacing and a hairline between
/// them (iOS 18+); give each row `.dsRow()` padding, or use `DSRowButtonStyle`
/// for a tappable row. A row with a leading icon moves its divider's start with
/// `.dsRowDividerInset(_:)`.
///
/// ```swift
/// DSGroupedSection("Você", footer: "Aparece nos alertas.") {
///     Toggle("Detecção de queda", isOn: $fall).dsRow()
///     Button("Perfil", action: openProfile).buttonStyle(DSRowButtonStyle(showsChevron: true))
/// }
/// ```
public struct DSGroupedSection<Header: View, Content: View, Footer: View>: View {
    @Environment(\.dsSurfaceLevel) private var level

    private let header: Header
    private let content: Content
    private let footer: Footer

    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            header
                .font(DSTypography.headline())
                .foregroundStyle(Color.onSurfaceHigh)
                .accessibilityAddTraits(.isHeader)

            rows
                .dsSurfaceContainer()
                .background(Color.surface(level: level))
                .clipShape(shape)
                .overlay(shape.strokeBorder(Color.hairline, lineWidth: 0.75))

            footer
                .font(DSTypography.footnote())
                .foregroundStyle(Color.onSurfaceMedium)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, DSSpacing.xs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous)
    }

    @ViewBuilder
    private var rows: some View {
        if #available(iOS 18.0, *) {
            Group(subviews: content) { subviews in
                VStack(spacing: 0) {
                    ForEach(Array(subviews.enumerated()), id: \.element.id) { index, row in
                        if index > 0 {
                            Rectangle()
                                .fill(Color.border)
                                .frame(height: 0.5)
                                .padding(.leading, row.containerValues.dsRowDividerInset ?? DSSpacing.lg)
                        }

                        row
                    }
                }
            }
        } else {
            VStack(spacing: 0) {
                content
            }
        }
    }
}

public extension DSGroupedSection where Header == Text?, Footer == Text? {
    /// A section with an optional plain title and footer.
    init(
        _ title: LocalizedStringKey? = nil,
        footer: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(content: content, header: { title.map { Text($0) } }, footer: { footer.map { Text($0) } })
    }
}

public extension DSGroupedSection where Footer == EmptyView {
    /// A section with a custom header (a title with a trailing action, a dynamic title).
    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header) {
        self.init(content: content, header: header, footer: { EmptyView() })
    }
}

public extension DSGroupedSection where Header == Text? {
    /// A section with a plain title and a custom footer (styled text, a link).
    init(
        _ title: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(content: content, header: { title.map { Text($0) } }, footer: footer)
    }
}

// MARK: - Rows

@available(iOS 18.0, *)
extension ContainerValues {
    @Entry var dsRowDividerInset: CGFloat?
}

public extension View {
    /// A row's padding inside a `DSGroupedSection`: the same insets an
    /// inset-grouped list gives its rows, at least 44 pt tall.
    func dsRow() -> some View {
        padding(.horizontal, DSSpacing.lg)
            .padding(.vertical, DSSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .contentShape(Rectangle())
    }

    /// Where the hairline above this row starts, from the section's leading
    /// edge — past a leading icon, as in iOS Settings. Default: the row inset.
    @ViewBuilder
    func dsRowDividerInset(_ inset: CGFloat) -> some View {
        if #available(iOS 18.0, *) {
            containerValue(\.dsRowDividerInset, inset)
        } else {
            self
        }
    }
}

/// A tappable row inside a `DSGroupedSection`: row padding, the pressed
/// highlight of a list cell and, for a row that leads somewhere, a chevron.
public struct DSRowButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private let showsChevron: Bool

    public init(showsChevron: Bool = false) {
        self.showsChevron = showsChevron
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: DSSpacing.sm) {
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(Color.onSurfaceLight)
                    .accessibilityHidden(true)
            }
        }
        .dsRow()
        .background(configuration.isPressed ? Color.onSurfaceHigh.opacity(0.08) : Color.clear)
        .opacity(isEnabled ? 1 : 0.45)
    }
}

#if DEBUG
private struct DSGroupedSectionPreviewHost: View {
    @State private var fall = true
    @State private var name = ""

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSGroupedSection("Você", footer: "Aparece nos alertas aos seus contatos.") {
                    Button {} label: {
                        Label("Perfil", systemImage: "person.text.rectangle")
                    }
                    .buttonStyle(DSRowButtonStyle(showsChevron: true))

                    Button {} label: {
                        Label("Contatos de confiança", systemImage: "person.2.fill")
                    }
                    .buttonStyle(DSRowButtonStyle(showsChevron: true))
                }

                DSGroupedSection("Durante a visita") {
                    Toggle("Detecção de queda", isOn: $fall)
                        .dsRow()

                    TextField("Nome", text: $name)
                        .dsRow()
                }

                DSCard {
                    Text("A card next to the sections: the same corner.")
                }
            }
            .padding(DSSpacing.lg)
        }
        .dsGroupedCanvas()
    }
}

#Preview("Grouped section") {
    DSGroupedSectionPreviewHost()
}

#Preview("Grouped section — dark") {
    DSGroupedSectionPreviewHost()
        .preferredColorScheme(.dark)
}
#endif
