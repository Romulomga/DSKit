import SwiftUI

/// One option in a `DSSegmentedPicker`.
public struct DSSegmentedOption<Value: Hashable>: Identifiable {
    public let id: Value
    public let label: LocalizedStringKey

    public init(_ value: Value, label: LocalizedStringKey) {
        self.id = value
        self.label = label
    }
}

/// How a `DSSegmentedPicker` is drawn.
public enum DSSegmentedStyle: Sendable {
    /// The system segmented control, tinted with the theme.
    case system
    /// A pill: a soft track with the selected option on a capsule in the theme's primary color.
    case filled
}

/// Segmented picker with an optional caption label: the system control (`.system`)
/// or a pill whose selected option sits on a capsule in the primary color (`.filled`).
public struct DSSegmentedPicker<Value: Hashable>: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var selectionNamespace

    private let title: LocalizedStringKey?
    @Binding private var selection: Value
    private let options: [DSSegmentedOption<Value>]
    private let style: DSSegmentedStyle

    public init(
        _ title: LocalizedStringKey? = nil,
        selection: Binding<Value>,
        options: [DSSegmentedOption<Value>],
        style: DSSegmentedStyle = .system
    ) {
        self.title = title
        self._selection = selection
        self.options = options
        self.style = style
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            switch style {
            case .system:
                systemPicker
            case .filled:
                filledPicker
            }
        }
    }

    private var systemPicker: some View {
        Picker(selection: $selection) {
            ForEach(options) { option in
                Text(option.label).tag(option.id)
            }
        } label: {
            if let title {
                Text(title)
            } else {
                Text(verbatim: "")
            }
        }
        .pickerStyle(.segmented)
        .tint(theme.primary)
    }

    /// Equal-width options on a `surface` track with a hairline; the primary capsule slides
    /// to the selected one (it jumps under Reduce Motion). Every option is a button with the
    /// selected trait, so VoiceOver reads "selecionado" on the current one.
    private var filledPicker: some View {
        HStack(spacing: 0) {
            ForEach(options) { option in
                let isSelected = option.id == selection

                Button {
                    selection = option.id
                } label: {
                    Text(option.label)
                        .font(DSTypography.footnote().weight(.semibold))
                        .foregroundStyle(isSelected ? Color.white : Color.onSurfaceMedium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, DSSpacing.sm)
                        .frame(maxWidth: .infinity, minHeight: Self.filledHeight)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(theme.primary)
                                    .matchedGeometryEffect(id: Self.selectionID, in: selectionNamespace)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(DSSpacing.xxs)
        .background(Color.surface, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.hairline, lineWidth: 1))
        .animation(reduceMotion ? nil : DSMotion.medium, value: selection)
        .accessibilityElement(children: .contain)
    }

    private static var filledHeight: CGFloat { 36 }
    private static var selectionID: String { "selection" }
}

#if DEBUG
private struct DSSegmentedPreviewHost: View {
    @State private var mode = "single"
    @State private var list = "active"

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            DSSegmentedPicker("Mode", selection: $mode, options: [
                DSSegmentedOption("single", label: "Single"),
                DSSegmentedOption("list", label: "List"),
                DSSegmentedOption("teams", label: "Teams")
            ])

            DSSegmentedPicker(selection: $list, options: [
                DSSegmentedOption("active", label: "4 Active items"),
                DSSegmentedOption("inactive", label: "1 Inactive item")
            ], style: .filled)
        }
    }
}

#Preview("Segmented picker") {
    DSPreviewContainer("Segmented picker") {
        DSSegmentedPreviewHost()
    }
}
#endif
