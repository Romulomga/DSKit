import SwiftUI
import UIKit

/// Multiline editor for entering a list of items (names, options). Parses by
/// newlines and reports item/duplicate counts but never mutates user input.
public struct DSListInput: View {
    private let title: String?
    private let placeholder: String
    @Binding private var text: String
    private let helperText: String?

    public init(
        title: String? = nil,
        placeholder: String = "One item per line",
        text: Binding<String>,
        helperText: String? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
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
                    .padding(.horizontal, DSSpacing.md - 2)
                    .padding(.vertical, DSSpacing.sm)
                    .frame(minHeight: 140)
            }
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))

            HStack(spacing: DSSpacing.md) {
                Label("\(itemCount) items", systemImage: "list.bullet")
                if duplicateCount > 0 {
                    Label("\(duplicateCount) duplicates", systemImage: "doc.on.doc")
                        .foregroundStyle(DSColor.warning)
                }
                Spacer()
                Button {
                    paste()
                } label: {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
                .buttonStyle(.plain)
                .foregroundStyle(DSColor.primary)
                Button(role: .destructive) {
                    text = ""
                    DSHaptics.light()
                } label: {
                    Label("Clear", systemImage: "trash")
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

    private func paste() {
        guard let s = UIPasteboard.general.string, !s.isEmpty else { return }
        if text.isEmpty {
            text = s
        } else {
            if !text.hasSuffix("\n") { text.append("\n") }
            text.append(s)
        }
        DSHaptics.light()
    }
}

#if DEBUG
private struct DSListInputPreviewHost: View {
    @State private var text = "Ana\nBruno\nCarla\nAna"
    var body: some View {
        DSListInput(
            title: "Participants",
            text: $text,
            helperText: "Enter one name per line. Duplicates are kept."
        )
    }
}

#Preview("List input") {
    DSPreviewContainer("List input") {
        DSListInputPreviewHost()
    }
}
#endif
