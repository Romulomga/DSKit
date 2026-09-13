import SwiftUI

/// Icons for the secure-entry reveal toggle. Defaults to `eye` / `eye.slash`.
public struct DSSecureToggleIcons: Sendable {
    public let show: Image
    public let hide: Image

    public init(show: Image, hide: Image) {
        self.show = show
        self.hide = hide
    }

    public static let system = DSSecureToggleIcons(show: Image(systemName: "eye"), hide: Image(systemName: "eye.slash"))
}

/// Styled text field: optional title, leading icon, secure entry with a reveal
/// toggle, helper/error caption and clear button. Keyboard, content type,
/// capitalization and submit label are parameters because the inner field is
/// private. Focus can be driven from outside through `focus`.
public struct DSTextField: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @FocusState private var isFocused: Bool
    @State private var isRevealed = false

    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    @Binding private var text: String
    private let errorMessage: LocalizedStringKey?
    private let helperText: LocalizedStringKey?
    private let isInvalid: Bool
    private let showsClearButton: Bool
    private let isSecure: Bool
    private let secureToggleIcons: DSSecureToggleIcons
    private let leadingIcon: Image?
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let autocapitalization: TextInputAutocapitalization?
    private let autocorrectionDisabled: Bool
    private let submitLabel: SubmitLabel
    private let focus: FocusState<Bool>.Binding?
    private let onSubmit: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = "",
        text: Binding<String>,
        errorMessage: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
        isInvalid: Bool = false,
        showsClearButton: Bool = false,
        isSecure: Bool = false,
        secureToggleIcons: DSSecureToggleIcons = .system,
        leadingIcon: Image? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization? = nil,
        autocorrectionDisabled: Bool = false,
        submitLabel: SubmitLabel = .return,
        focus: FocusState<Bool>.Binding? = nil,
        onSubmit: (() -> Void)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.isInvalid = isInvalid
        self.showsClearButton = showsClearButton
        self.isSecure = isSecure
        self.secureToggleIcons = secureToggleIcons
        self.leadingIcon = leadingIcon
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.submitLabel = submitLabel
        self.focus = focus
        self.onSubmit = onSubmit
        self.onEditingChanged = onEditingChanged
    }

    private var hasError: Bool { isInvalid || errorMessage != nil }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                DSFieldLabel(title)
            }

            DSInputBox(leadingIcon: leadingIcon, isFocused: isFocused, isInvalid: hasError, onTap: { isFocused = true }) {
                field
                    .textFieldStyle(.plain)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .submitLabel(submitLabel)
                    .focused($isFocused)
                    .onSubmit { onSubmit?() }

                if isSecure {
                    revealToggle
                } else if showsClearButton && !text.isEmpty {
                    clearButton
                }
            }
            .animation(.easeOut(duration: 0.15), value: errorMessage != nil)

            DSFieldCaption(errorMessage: errorMessage, helperText: helperText)
        }
        .onChange(of: isFocused) { _, focused in
            onEditingChanged?(focused)
            if let focus, focus.wrappedValue != focused { focus.wrappedValue = focused }
        }
        .onChange(of: focus?.wrappedValue ?? false) { _, external in
            if focus != nil, external != isFocused { isFocused = external }
        }
    }

    @ViewBuilder private var field: some View {
        if isSecure, !isRevealed {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text)
        }
    }

    private var revealToggle: some View {
        Button {
            isRevealed.toggle()
            DSHaptics.light(if: hapticsEnabled)
        } label: {
            // Fixed width only: the box already spans the tap-target height, and a
            // 44 pt minimum here would make secure fields taller than the others.
            (isRevealed ? secureToggleIcons.hide : secureToggleIcons.show)
                .foregroundStyle(.secondary)
                .frame(width: DSInputMetrics.tapTarget)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(isRevealed ? "Hide password" : "Show password", bundle: .dsKit))
    }

    private var clearButton: some View {
        Button {
            text = ""
            DSHaptics.light(if: hapticsEnabled)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.tertiary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Clear", bundle: .dsKit))
    }
}

#if DEBUG
private struct DSTextFieldPreviewHost: View {
    @State private var name = ""
    @State private var email = "bad@"
    @State private var password = "secret"
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSTextField(title: "Name", placeholder: "Your name", text: $name, showsClearButton: true)
            DSTextField(
                title: "Email", placeholder: "you@example.com", text: $email, errorMessage: "Invalid email",
                leadingIcon: Image(systemName: "envelope"), keyboardType: .emailAddress, textContentType: .emailAddress
            )
            DSTextField(
                title: "Password", placeholder: "Password", text: $password, helperText: "At least 4 characters",
                isSecure: true, leadingIcon: Image(systemName: "lock")
            )
        }
    }
}

#Preview("Text field · compact") {
    DSPreviewContainer("Text field") { DSTextFieldPreviewHost() }
}

#Preview("Text field · prominent") {
    DSPreviewContainer("Text field") { DSTextFieldPreviewHost() }
        .dsFieldLabelStyle(.prominent)
}
#endif
