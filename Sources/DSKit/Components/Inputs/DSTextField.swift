import SwiftUI

/// Styled text field with title, optional helper/error and optional clear button.
public struct DSTextField: View {
    private let title: String?
    private let placeholder: String
    @Binding private var text: String
    private let errorMessage: String?
    private let helperText: String?
    private let showsClearButton: Bool

    public init(
        title: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        errorMessage: String? = nil,
        helperText: String? = nil,
        showsClearButton: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.showsClearButton = showsClearButton
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: DSSpacing.sm) {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(DSTypography.body())
                if showsClearButton && !text.isEmpty {
                    Button {
                        text = ""
                        DSHaptics.light()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear")
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm + 2)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                    .strokeBorder(errorMessage != nil ? DSColor.error.opacity(0.6) : Color.clear,
                                  lineWidth: 1)
            )

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.circle.fill")
                    .font(DSTypography.footnote())
                    .foregroundStyle(DSColor.error)
            } else if let helperText {
                Text(helperText)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#if DEBUG
private struct DSTextFieldPreviewHost: View {
    @State private var name = ""
    @State private var email = "bad@"
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSTextField(title: "Name", placeholder: "Your name", text: $name, showsClearButton: true)
            DSTextField(title: "Email", placeholder: "you@example.com", text: $email, errorMessage: "Invalid email")
        }
    }
}

#Preview("Text field") {
    DSPreviewContainer("Text field") {
        DSTextFieldPreviewHost()
    }
}
#endif
