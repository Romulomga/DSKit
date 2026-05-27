import SwiftUI
import UIKit

/// Multiline editor for entering a list of items (names, options). Parses by
/// newlines and reports item/duplicate counts but never mutates user input.
public struct DSListInput: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @FocusState private var isFocused: Bool

    private let title: LocalizedStringKey?
    // Caller-provided localizable strings stay Optional. `nil` means "use
    // DSKit's bundled default"; a non-nil value resolves in the caller's
    // main bundle (where the app's xcstrings live). Without this split a
    // caller key that doesn't exist in DSKit's bundle would fall back to
    // the literal English value — which is what the placeholder bug was.
    private let placeholder: LocalizedStringKey?
    @Binding private var text: String
    private let helperText: LocalizedStringKey?

    private let itemLabel: (Int) -> LocalizedStringKey
    private let duplicateLabel: (Int) -> LocalizedStringKey
    private let pasteTitle: LocalizedStringKey?
    private let clearTitle: LocalizedStringKey?
    private let onClearRequested: (() -> Void)?

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey? = nil,
        text: Binding<String>,
        helperText: LocalizedStringKey? = nil,
        itemLabel: @escaping (Int) -> LocalizedStringKey = { count in "\(count) items" },
        duplicateLabel: @escaping (Int) -> LocalizedStringKey = { count in "\(count) duplicates" },
        pasteTitle: LocalizedStringKey? = nil,
        clearTitle: LocalizedStringKey? = nil,
        onClearRequested: (() -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
        self.itemLabel = itemLabel
        self.duplicateLabel = duplicateLabel
        self.pasteTitle = pasteTitle
        self.clearTitle = clearTitle
        self.onClearRequested = onClearRequested
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote().weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    placeholderText
                        .font(DSTypography.body())
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, DSSpacing.md + 4)
                        .padding(.vertical, DSSpacing.sm + 6)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $text)
                    .font(DSTypography.body())
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)
                    .padding(.horizontal, DSSpacing.md - 2)
                    .padding(.vertical, DSSpacing.sm)
                    .frame(minHeight: 140)
                    .toolbar {
                        if isFocused {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button {
                                    isFocused = false
                                } label: {
                                    Text("Done", bundle: .dsKit)
                                }
                            }
                        }
                    }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                    .strokeBorder(
                        isFocused ? Color.accent.opacity(0.7) : Color.border.opacity(0.5),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .animation(.easeOut(duration: 0.15), value: isFocused)

            HStack(spacing: DSSpacing.md) {
                Label {
                    // CLDR groups 0 with "one" in some locales (pt-BR among them),
                    // so the plural "%lld items" string would read "0 item" there.
                    // Pick a dedicated empty-state key instead.
                    if itemCount == 0 {
                        Text("No items", bundle: .dsKit)
                    } else {
                        Text(itemLabel(itemCount), bundle: .dsKit)
                    }
                } icon: {
                    Image(systemName: "list.bullet")
                }
                if duplicateCount > 0 {
                    Label {
                        Text(duplicateLabel(duplicateCount), bundle: .dsKit)
                    } icon: {
                        Image(systemName: "doc.on.doc")
                    }
                    .foregroundStyle(Color.warningHigh)
                }
                Spacer()
                Button {
                    paste()
                } label: {
                    Label {
                        pasteLabel
                    } icon: {
                        Image(systemName: "doc.on.clipboard")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.accent)
                Button(role: .destructive) {
                    handleClearTap()
                } label: {
                    Label {
                        clearLabel
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(text.isEmpty ? Color.secondary : Color.errorHigh)
                .disabled(text.isEmpty)
            }
            .font(DSTypography.footnote())
            .foregroundStyle(.secondary)
            .labelStyle(.titleAndIcon)

            if let helperText {
                Text(helperText)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var placeholderText: some View {
        if let placeholder {
            Text(placeholder)
        } else {
            Text("One item per line", bundle: .dsKit)
        }
    }

    @ViewBuilder
    private var pasteLabel: some View {
        if let pasteTitle {
            Text(pasteTitle)
        } else {
            Text("Paste", bundle: .dsKit)
        }
    }

    @ViewBuilder
    private var clearLabel: some View {
        if let clearTitle {
            Text(clearTitle)
        } else {
            Text("Clear", bundle: .dsKit)
        }
    }

    /// Non-empty trimmed lines.
    public var lines: [String] {
        text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    public var itemCount: Int { lines.count }

    public var duplicateCount: Int {
        let lowered = lines.map { $0.lowercased() }
        return lowered.count - Set(lowered).count
    }

    private func handleClearTap() {
        DSHaptics.light(if: hapticsEnabled)
        if let onClearRequested {
            onClearRequested()
        } else {
            text = ""
        }
    }

    private func paste() {
        guard let s = UIPasteboard.general.string, !s.isEmpty else { return }
        if text.isEmpty {
            text = s
        } else {
            if !text.hasSuffix("\n") { text.append("\n") }
            text.append(s)
        }
        DSHaptics.light(if: hapticsEnabled)
    }
}

#if DEBUG
private struct DSListInputPreviewHost: View {
    @State private var text = "Ana\nBruno\nCarla\nAna"
    @State private var showConfirm = false
    var body: some View {
        DSListInput(
            title: "Participants",
            text: $text,
            helperText: "Enter one name per line. Duplicates are kept.",
            onClearRequested: { showConfirm = true }
        )
        .confirmationDialog("Clear list?", isPresented: $showConfirm, titleVisibility: .visible) {
            Button("Clear", role: .destructive) { text = "" }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview("List input") {
    DSPreviewContainer("List input") {
        DSListInputPreviewHost()
    }
}
#endif
