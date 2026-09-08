import SwiftUI

// MARK: - Label style

/// Sizing of field labels and captions across DSKit inputs.
/// `.compact` is the default (footnote, secondary colour). `.prominent` uses
/// subheadline labels in the primary colour and italic error lines, for apps
/// whose forms need more presence. Set once at the app root with
/// `.dsFieldLabelStyle(_:)`.
public enum DSFieldLabelStyle: Sendable, Equatable {
    case compact
    case prominent
}

private struct DSFieldLabelStyleKey: EnvironmentKey {
    static let defaultValue: DSFieldLabelStyle = .compact
}

public extension EnvironmentValues {
    var dsFieldLabelStyle: DSFieldLabelStyle {
        get { self[DSFieldLabelStyleKey.self] }
        set { self[DSFieldLabelStyleKey.self] = newValue }
    }
}

public extension View {
    /// Label/caption sizing for every DSKit input in the subtree.
    func dsFieldLabelStyle(_ style: DSFieldLabelStyle) -> some View {
        environment(\.dsFieldLabelStyle, style)
    }
}

// MARK: - Label & caption

/// Title above an input. Use it for custom inputs so they line up with `DSTextField`.
public struct DSFieldLabel: View {
    @Environment(\.dsFieldLabelStyle) private var style
    private let title: LocalizedStringKey

    public init(_ title: LocalizedStringKey) {
        self.title = title
    }

    public var body: some View {
        switch style {
        case .compact:
            Text(title)
                .font(DSTypography.footnote().weight(.semibold))
                .foregroundStyle(.secondary)
        case .prominent:
            Text(title)
                .font(DSTypography.subheadline().weight(.bold))
                .foregroundStyle(Color.onSurfaceHigh)
        }
    }
}

/// Error or helper line under an input. Error wins when both are set.
public struct DSFieldCaption: View {
    @Environment(\.dsFieldLabelStyle) private var style
    private let errorMessage: LocalizedStringKey?
    private let helperText: LocalizedStringKey?

    public init(errorMessage: LocalizedStringKey? = nil, helperText: LocalizedStringKey? = nil) {
        self.errorMessage = errorMessage
        self.helperText = helperText
    }

    public var body: some View {
        if let errorMessage {
            error(errorMessage)
                .foregroundStyle(Color.errorHigh)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        } else if let helperText {
            Text(helperText)
                .font(DSTypography.footnote())
                .italic(style == .prominent)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func error(_ message: LocalizedStringKey) -> some View {
        switch style {
        case .compact:
            Label {
                Text(message)
            } icon: {
                Image(systemName: "exclamationmark.circle.fill")
            }
            .font(DSTypography.footnote())
        case .prominent:
            Text(message)
                .font(DSTypography.subheadline())
                .italic()
        }
    }
}

// MARK: - Input box

/// The container every DSKit input sits in: surface, rounded corners and a
/// border that tells the state (hairline → accent on focus → error red).
/// Build custom inputs (code fields, paired fields, pickers) on top of it so
/// they match `DSTextField` exactly. Tapping the box calls `onTap`, which
/// custom inputs use to move focus into their field.
public struct DSInputBox<Content: View>: View {
    @Environment(\.dsSurfaceLevel) private var level

    private let leadingIcon: Image?
    private let isFocused: Bool
    private let isInvalid: Bool
    private let onTap: (() -> Void)?
    private let content: Content

    public init(
        leadingIcon: Image? = nil,
        isFocused: Bool = false,
        isInvalid: Bool = false,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.leadingIcon = leadingIcon
        self.isFocused = isFocused
        self.isInvalid = isInvalid
        self.onTap = onTap
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            if let leadingIcon {
                leadingIcon
                    .frame(width: DSInputMetrics.iconWidth)
                    .accessibilityHidden(true)
            }
            content
        }
        .font(DSTypography.body())
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm + 2)
        .frame(maxWidth: .infinity, minHeight: DSInputMetrics.minHeight)
        .background(Color.surface(level: level))
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous)
                .strokeBorder(DSInputMetrics.borderColor(isFocused: isFocused, isInvalid: isInvalid),
                              lineWidth: DSInputMetrics.borderWidth(isFocused: isFocused, isInvalid: isInvalid))
        )
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
        .animation(.easeOut(duration: 0.15), value: isFocused)
        .animation(.easeOut(duration: 0.15), value: isInvalid)
    }
}

/// Shared numbers so every input has the same silhouette.
public enum DSInputMetrics {
    public static let minHeight: CGFloat = 45
    public static let iconWidth: CGFloat = 20
    /// Minimum hit area for controls inside a field (Apple HIG).
    public static let tapTarget: CGFloat = 44

    public static func borderColor(isFocused: Bool, isInvalid: Bool) -> Color {
        if isInvalid { return Color.errorHigh.opacity(0.7) }
        if isFocused { return Color.accent.opacity(0.7) }
        return Color.hairline
    }

    public static func borderWidth(isFocused: Bool, isInvalid: Bool) -> CGFloat {
        (isFocused || isInvalid) ? 1.5 : 1
    }
}

#if DEBUG
private struct DSInputBoxPreviewHost: View {
    @State private var text = ""
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSFieldLabel("Custom input")
            DSInputBox(leadingIcon: Image(systemName: "person")) { TextField("Type", text: $text) }
            DSFieldLabel("Invalid")
            DSInputBox(isInvalid: true) { TextField("Type", text: $text) }
            DSFieldCaption(errorMessage: "Something is off")
        }
    }
}

#Preview("Input box · compact") {
    DSPreviewContainer("Input box") { DSInputBoxPreviewHost() }
}

#Preview("Input box · prominent") {
    DSPreviewContainer("Input box") { DSInputBoxPreviewHost() }
        .dsFieldLabelStyle(.prominent)
}
#endif
