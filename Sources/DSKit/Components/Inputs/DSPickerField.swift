import SwiftUI

/// One option in a `DSPickerField`.
public struct DSPickerOption<Value: Hashable>: Identifiable {
    public let id: Value
    public let label: LocalizedStringKey

    public init(_ value: Value, label: LocalizedStringKey) {
        self.id = value
        self.label = label
    }
}

/// Single-choice field that looks like `DSTextField` and opens a menu:
/// optional title, placeholder while nothing is selected, chevron (or a custom
/// trailing icon), error/helper caption. `hugsContent` makes it as narrow as
/// its label, for pickers that sit beside a text field.
public struct DSPickerField<Value: Hashable>: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    @Binding private var selection: Value?
    private let options: [DSPickerOption<Value>]
    private let errorMessage: LocalizedStringKey?
    private let helperText: LocalizedStringKey?
    private let isInvalid: Bool
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let hugsContent: Bool

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey,
        selection: Binding<Value?>,
        options: [DSPickerOption<Value>],
        errorMessage: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
        isInvalid: Bool = false,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        hugsContent: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._selection = selection
        self.options = options
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.isInvalid = isInvalid
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.hugsContent = hugsContent
    }

    private var selectedLabel: LocalizedStringKey? {
        options.first { $0.id == selection }?.label
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                DSFieldLabel(title)
            }

            Menu {
                ForEach(options) { option in
                    Button {
                        selection = option.id
                        DSHaptics.light(if: hapticsEnabled)
                    } label: {
                        Text(option.label)
                    }
                }
            } label: {
                DSInputBox(leadingIcon: leadingIcon, isInvalid: isInvalid || errorMessage != nil) {
                    Text(selectedLabel ?? placeholder)
                        .foregroundStyle(selectedLabel == nil ? Color.onSurfaceMedium : Color.onSurfaceHigh)
                        .lineLimit(1)

                    if !hugsContent {
                        Spacer(minLength: 0)
                    }

                    (trailingIcon ?? Image(systemName: "chevron.down"))
                        .font(DSTypography.footnote().weight(.semibold))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                .fixedSize(horizontal: hugsContent, vertical: false)
            }
            .accessibilityLabel(Text(title ?? placeholder))
            .accessibilityValue(Text(selectedLabel ?? "Not selected", bundle: .dsKit))

            DSFieldCaption(errorMessage: errorMessage, helperText: helperText)
        }
    }
}

#if DEBUG
private struct DSPickerFieldPreviewHost: View {
    @State private var state: String?
    @State private var number = ""
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSPickerField(
                title: "State", placeholder: "Choose", selection: $state,
                options: ["RJ", "SP", "MG"].map { DSPickerOption($0, label: LocalizedStringKey($0)) }
            )
            HStack(spacing: DSSpacing.sm) {
                DSTextField(placeholder: "Number", text: $number, keyboardType: .numberPad)
                DSPickerField(
                    placeholder: "UF", selection: $state,
                    options: ["RJ", "SP"].map { DSPickerOption($0, label: LocalizedStringKey($0)) },
                    isInvalid: true, hugsContent: true
                )
            }
            DSFieldCaption(errorMessage: "Pick a state")
        }
    }
}

#Preview("Picker field") {
    DSPreviewContainer("Picker field") { DSPickerFieldPreviewHost() }
}
#endif
