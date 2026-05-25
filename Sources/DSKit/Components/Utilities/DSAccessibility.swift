import SwiftUI

/// Small helpers for VoiceOver labels.
public enum DSAccessibility {
    /// Joins non-empty trimmed parts with `, ` — useful when a card combines
    /// title + subtitle + badge into a single VoiceOver utterance.
    public static func combinedLabel(_ parts: String?...) -> String {
        parts
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

public extension View {
    /// Collapse a composite view into one accessibility element with a
    /// combined label, optionally with a hint.
    func dsAccessibleCard(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}
