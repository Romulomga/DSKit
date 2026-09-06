import SwiftUI

/// Selectable color swatch with optional lock state, used for theme
/// pickers and accent-color settings.
public struct DSColorSwatch: View {
    private let color: Color
    private let label: LocalizedStringKey
    private let isSelected: Bool
    private let isLocked: Bool
    private let action: () -> Void

    public init(
        color: Color,
        label: LocalizedStringKey,
        isSelected: Bool,
        isLocked: Bool = false,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.label = label
        self.isSelected = isSelected
        self.isLocked = isLocked
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: DSSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 56, height: 56)
                    if isSelected {
                        Circle()
                            .strokeBorder(Color.onSurfaceHigh, lineWidth: 3)
                            .frame(width: 64, height: 64)
                    }
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                Text(label)
                    .font(DSTypography.caption())
                    .foregroundStyle(Color.onSurfaceHigh)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        .accessibilityLabel(Text(label))
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }
}

#if DEBUG
private struct DSColorSwatchPreviewHost: View {
    @State private var selected: Color = .indigo
    private let palette: [(Color, LocalizedStringKey, Bool)] = [
        (.indigo, "Indigo", false),
        (.blue,   "Blue",   false),
        (.teal,   "Teal",   true),
        (.green,  "Green",  true),
        (.orange, "Orange", true)
    ]
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: DSSpacing.md)], spacing: DSSpacing.md) {
            ForEach(palette.indices, id: \.self) { i in
                let (color, label, locked) = palette[i]
                DSColorSwatch(
                    color: color,
                    label: label,
                    isSelected: selected == color,
                    isLocked: locked,
                    action: { if !locked { selected = color } }
                )
            }
        }
    }
}

#Preview("Color swatch") {
    DSPreviewContainer("Color swatch") {
        DSColorSwatchPreviewHost()
    }
}
#endif
