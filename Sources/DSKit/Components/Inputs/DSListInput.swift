import SwiftUI
import UIKit

/// Multiline editor for entering a list of items (names, options). Parses by
/// newlines and reports item/duplicate counts but never mutates user input.
public struct DSListInput: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled
    @FocusState private var isFocused: Bool

    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    @Binding private var text: String
    private let helperText: LocalizedStringKey?

    private let itemLabel: (Int) -> String
    private let duplicateLabel: (Int) -> String
    private let pasteTitle: LocalizedStringKey
    private let clearTitle: LocalizedStringKey
    private let onClearRequested: (() -> Void)?

    public init(
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = LocalizedStringKey(String(localized: "One item per line", bundle: .dsKit)),
        text: Binding<String>,
        helperText: LocalizedStringKey? = nil,
        itemLabel: @escaping (Int) -> String = { count in
            String(localized: "\(count) items", bundle: .dsKit)
        },
        duplicateLabel: @escaping (Int) -> String = { count in
            String(localized: "\(count) duplicates", bundle: .dsKit)
        },
        pasteTitle: LocalizedStringKey = LocalizedStringKey(String(localized: "Paste", bundle: .dsKit)),
        clearTitle: LocalizedStringKey = LocalizedStringKey(String(localized: "Clear", bundle: .dsKit)),
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
                    Text(placeholder)
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
            }
            .background(DSColor.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                    .strokeBorder(
                        isFocused ? DSColor.primary.opacity(0.7) : DSColor.border.opacity(0.5),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .animation(.easeOut(duration: 0.15), value: isFocused)

            HStack(spacing: DSSpacing.md) {
                Label {
                    Text(itemLabel(itemCount))
                } icon: {
                    Image(systemName: "list.bullet")
                }
                if duplicateCount > 0 {
                    Label {
                        Text(duplicateLabel(duplicateCount))
                    } icon: {
                        Image(systemName: "doc.on.doc")
                    }
                    .foregroundStyle(DSColor.warning)
                }
                Spacer()
                Button {
                    paste()
                } label: {
                    Label(pasteTitle, systemImage: "doc.on.clipboard")
                }
                .buttonStyle(.plain)
                .foregroundStyle(DSColor.primary)
                Button(role: .destructive) {
                    handleClearTap()
                } label: {
                    Label(clearTitle, systemImage: "trash")
                }
                .buttonStyle(.plain)
                .foregroundStyle(text.isEmpty ? Color.secondary : DSColor.error)
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
