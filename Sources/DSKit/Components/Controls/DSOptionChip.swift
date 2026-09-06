import SwiftUI

/// Capsule-shaped selectable chip — single chip with toggle behavior. Use
/// inside a wrapping `HStack` / flow layout for filter groups.
public struct DSOptionChip: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    private let title: LocalizedStringKey
    private let systemImage: String?
    @Binding private var isSelected: Bool

    public init(_ title: LocalizedStringKey, systemImage: String? = nil, isSelected: Binding<Bool>) {
        self.title = title
        self.systemImage = systemImage
        self._isSelected = isSelected
    }

    public var body: some View {
        Button {
            isSelected.toggle()
            DSHaptics.light(if: hapticsEnabled)
        } label: {
            HStack(spacing: DSSpacing.xs) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(DSTypography.subheadline().weight(.semibold))
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .foregroundStyle(isSelected ? Color.white : theme.primary)
            .background(isSelected ? theme.primary : theme.primary.opacity(0.12))
            .clipShape(Capsule())
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(title)
    }
}

#if DEBUG
private struct DSOptionChipPreviewHost: View {
    @State private var allowsDuplicates = false
    @State private var noRepeats = true
    @State private var shuffle = false

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            DSOptionChip("Duplicates", systemImage: "doc.on.doc", isSelected: $allowsDuplicates)
            DSOptionChip("No repeats", systemImage: "checkmark.seal", isSelected: $noRepeats)
            DSOptionChip("Shuffle", systemImage: "shuffle", isSelected: $shuffle)
        }
    }
}

#Preview("Option chip") {
    DSPreviewContainer("Option chip") {
        DSOptionChipPreviewHost()
    }
}
#endif
