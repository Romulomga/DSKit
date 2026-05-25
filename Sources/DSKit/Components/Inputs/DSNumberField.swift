import SwiftUI

/// Text field specialised for integer input. Exposes a `Binding<Int?>` so
/// `nil` cleanly represents an empty/invalid state.
public struct DSNumberField: View {
    private let title: String?
    private let placeholder: String
    @Binding private var value: Int?
    private let externalError: String?

    @State private var text: String = ""
    @State private var internalError: String? = nil

    public init(
        title: String? = nil,
        placeholder: String = "0",
        value: Binding<Int?>,
        errorMessage: String? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
        self.externalError = errorMessage
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
                        .strokeBorder(displayedError != nil ? DSColor.error.opacity(0.6) : Color.clear,
                                      lineWidth: 1)
                )
                .onAppear {
                    if let v = value, text.isEmpty {
                        text = String(v)
                    }
                }
                .onChange(of: text) { _, newValue in
                    validate(newValue)
                }

            if let msg = displayedError {
                Label(msg, systemImage: "exclamationmark.circle.fill")
                    .font(DSTypography.footnote())
                    .foregroundStyle(DSColor.error)
            }
        }
    }

    private var displayedError: String? { externalError ?? internalError }

    private func validate(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            value = nil
            internalError = nil
            return
        }
        if let n = Int(trimmed) {
            value = n
            internalError = nil
        } else {
            value = nil
            internalError = "Enter a valid number"
        }
    }
}

#if DEBUG
private struct DSNumberFieldPreviewHost: View {
    @State private var minimum: Int? = 1
    @State private var maximum: Int? = 100
    var body: some View {
        HStack(spacing: DSSpacing.md) {
            DSNumberField(title: "Min", value: $minimum)
            DSNumberField(title: "Max", value: $maximum)
        }
    }
}

#Preview("Number field") {
    DSPreviewContainer("Number field") {
        DSNumberFieldPreviewHost()
    }
}
#endif
