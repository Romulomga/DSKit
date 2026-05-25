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

/// Thin wrapper over `Picker(.segmented)` with an optional caption label and
/// theme-aware tint.
public struct DSSegmentedPicker<Value: Hashable>: View {
    @Environment(\.dsTheme) private var theme

    private let title: LocalizedStringKey?
    @Binding private var selection: Value
    private let options: [DSSegmentedOption<Value>]

    public init(
        _ title: LocalizedStringKey? = nil,
        selection: Binding<Value>,
        options: [DSSegmentedOption<Value>]
    ) {
        self.title = title
        self._selection = selection
        self.options = options
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }
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
    }
}

#if DEBUG
private struct DSSegmentedPreviewHost: View {
    @State private var mode = "single"
    var body: some View {
        DSSegmentedPicker("Mode", selection: $mode, options: [
            DSSegmentedOption("single", label: "Single"),
            DSSegmentedOption("list", label: "List"),
            DSSegmentedOption("teams", label: "Teams")
        ])
    }
}

#Preview("Segmented picker") {
    DSPreviewContainer("Segmented picker") {
        DSSegmentedPreviewHost()
    }
}
#endif
