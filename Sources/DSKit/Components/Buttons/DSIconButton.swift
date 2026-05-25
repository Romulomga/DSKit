import SwiftUI

/// Compact icon-only button. Use `.tinted` for toolbar-style actions, `.filled`
/// for emphasized circular CTAs, `.plain` for inline icon affordances.
public struct DSIconButton: View {
    public enum Style: Sendable { case plain, tinted, filled }
    public enum IconShape: Sendable { case circle, rounded }

    @Environment(\.dsTheme) private var theme

    private let systemImage: String
    private let style: Style
    private let shape: IconShape
    private let label: String
    private let action: () -> Void

    public init(
        systemImage: String,
        style: Style = .tinted,
        shape: IconShape = .circle,
        accessibilityLabel label: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.style = style
        self.shape = shape
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.light()
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(foreground)
                .frame(width: 44, height: 44)
                .background(background)
                .clipShape(clipShape)
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(label)
    }

    private var foreground: Color {
        switch style {
        case .plain, .tinted: theme.primary
        case .filled: .white
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .plain: Color.clear
        case .tinted: theme.primary.opacity(0.15)
        case .filled: theme.primary
        }
    }

    private var clipShape: AnyShape {
        switch shape {
        case .circle: AnyShape(Circle())
        case .rounded: AnyShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
        }
    }
}

#if DEBUG
#Preview("Icon button") {
    DSPreviewContainer("Icon button") {
        HStack(spacing: DSSpacing.md) {
            DSIconButton(systemImage: "square.and.arrow.up", style: .plain, accessibilityLabel: "Share") {}
            DSIconButton(systemImage: "doc.on.doc", style: .tinted, accessibilityLabel: "Copy") {}
            DSIconButton(systemImage: "plus", style: .filled, accessibilityLabel: "Add") {}
            DSIconButton(systemImage: "gear", style: .tinted, shape: .rounded, accessibilityLabel: "Settings") {}
        }
    }
}
#endif
