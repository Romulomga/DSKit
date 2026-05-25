import SwiftUI

/// Text field specialised for integer input. Exposes a `Binding<Int?>` so
/// `nil` cleanly represents an empty/invalid state.
public struct DSNumberField: View {
    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    @Binding private var value: Int?
    private let externalError: LocalizedStringKey?
    private let invalidNumberMessage: LocalizedStringKey

    @State private var text: String = ""
    @State private var hasInternalError: Bool = false

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = "0",
        value: Binding<Int?>,
        errorMessage: LocalizedStringKey? = nil,
        invalidNumberMessage: LocalizedStringKey = LocalizedStringKey(String(localized: "Enter a valid number", bundle: .dsKit))
    ) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
        self.externalError = errorMessage
        self.invalidNumberMessage = invalidNumberMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            TextField(placeholder, text: $text)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(.plain)
                .font(DSTypography.body())
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm + 2)
                .background(DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                        .strokeBorder(hasAnyError ? DSColor.error.opacity(0.6) : Color.clear,
                                      lineWidth: 1)
                )
                .onAppear {
                    let target = value.map(String.init) ?? ""
                    if text != target { text = target }
                }
                .onChange(of: text) { _, newValue in
                    validate(newValue)
                }
                .onChange(of: value) { _, newValue in
                    let target = newValue.map(String.init) ?? ""
                    if text != target {
                        text = target
                        hasInternalError = false
                    }
                }

            if let externalError {
                errorLabel(externalError)
            } else if hasInternalError {
                errorLabel(invalidNumberMessage)
            }
        }
    }

    private var hasAnyError: Bool { externalError != nil || hasInternalError }

    @ViewBuilder
    private func errorLabel(_ key: LocalizedStringKey) -> some View {
        Label {
            Text(key)
        } icon: {
            Image(systemName: "exclamationmark.circle.fill")
        }
        .font(DSTypography.footnote())
        .foregroundStyle(DSColor.error)
    }

    private func validate(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            value = nil
            hasInternalError = false
            return
        }
        if let n = Int(trimmed) {
            value = n
            hasInternalError = false
        } else {
            value = nil
            hasInternalError = true
        }
    }
}

#if DEBUG
private struct DSNumberFieldPreviewHost: View {
    @State private var minimum: Int? = 1
    @State private var maximum: Int? = 100
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            HStack(spacing: DSSpacing.md) {
                DSNumberField(title: "Min", value: $minimum)
                DSNumberField(title: "Max", value: $maximum)
            }
            DSSecondaryButton("Reset") {
                minimum = 1
                maximum = 100
            }
        }
    }
}

#Preview("Number field") {
    DSPreviewContainer("Number field") {
        DSNumberFieldPreviewHost()
    }
}
#endif
