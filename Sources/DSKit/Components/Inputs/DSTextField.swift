import SwiftUI

/// Styled text field with title, optional helper/error and optional clear button.
public struct DSTextField: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @FocusState private var isFocused: Bool

    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    @Binding private var text: String
    private let errorMessage: LocalizedStringKey?
    private let helperText: LocalizedStringKey?
    private let showsClearButton: Bool

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = "",
        text: Binding<String>,
        errorMessage: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
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
                    .focused($isFocused)
                if showsClearButton && !text.isEmpty {
                    Button {
                        text = ""
                        DSHaptics.light(if: hapticsEnabled)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("Clear"))
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm + 2)
            .background(DSColor.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .animation(.easeOut(duration: 0.15), value: isFocused)
            .animation(.easeOut(duration: 0.15), value: errorMessage != nil)

            if let errorMessage {
                Label {
                    Text(errorMessage)
                } icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                }
                .font(DSTypography.footnote())
                .foregroundStyle(DSColor.error)
            } else if let helperText {
                Text(helperText)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var borderColor: Color {
        if errorMessage != nil { return DSColor.error.opacity(0.7) }
        if isFocused           { return DSColor.primary.opacity(0.7) }
        return DSColor.border.opacity(0.5)
    }

    private var borderWidth: CGFloat {
        (isFocused || errorMessage != nil) ? 1.5 : 1
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
