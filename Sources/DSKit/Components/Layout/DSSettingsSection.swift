import SwiftUI

/// Grouped settings-style section. Contains `DSSettingsRow`s and renders a
/// rounded grouped surface like iOS Settings.
public struct DSSettingsSection<Content: View>: View {
    private let title: LocalizedStringKey?
    private let footer: LocalizedStringKey?
    private let content: Content

    public init(
        _ title: LocalizedStringKey? = nil,
        footer: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.footer = footer
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title {
                Text(title)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .padding(.horizontal, DSSpacing.md)
            }
            VStack(spacing: 0) {
                content
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.md, style: .continuous))
            if let footer {
                Text(footer)
                    .font(DSTypography.footnote())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, DSSpacing.md)
            }
        }
    }
}

/// One row inside a `DSSettingsSection`. Supports leading icon, title,
/// subtitle, trailing content (toggle/value/chevron) and an optional action.
/// Set `showsDivider: false` on the last row of a section for the iOS Settings look.
public struct DSSettingsRow: View {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    private let systemImage: String?
    private let iconColor: Color?
    private let title: LocalizedStringKey
    private let subtitle: LocalizedStringKey?
    private let trailing: AnyView
    private let action: (() -> Void)?
    private let showsDivider: Bool

    public init(
        systemImage: String? = nil,
        iconColor: Color? = nil,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(EmptyView())
        self.action = action
        self.showsDivider = showsDivider
    }

    public init<Trailing: View>(
        systemImage: String? = nil,
        iconColor: Color? = nil,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(trailing())
        self.action = action
        self.showsDivider = showsDivider
    }

    public var body: some View {
        rowContainer
            .overlay(alignment: .bottom) {
                if showsDivider {
                    Rectangle()
                        .fill(Color.border)
                        .frame(height: 0.5)
                        .padding(.leading, DSSpacing.md + 28 + DSSpacing.md)
                }
            }
    }

    // A tappable Button only when there's a row action. Otherwise a plain
    // container — wrapping a toggle/value row in a Button forced us to
    // `.disabled(action == nil)`, which propagated down and made the trailing
    // control inert (and dimmed the whole row). Branching keeps it live.
    @ViewBuilder
    private var rowContainer: some View {
        if let action {
            Button {
                DSHaptics.light(if: hapticsEnabled)
                action()
            } label: {
                rowLabel
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
        } else {
            rowLabel
        }
    }

    @ViewBuilder
    private var rowLabel: some View {
        HStack(spacing: DSSpacing.md) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(iconColor ?? Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTypography.body())
                    .foregroundStyle(Color.onSurfaceHigh)
                if let subtitle {
                    Text(subtitle)
                        .font(DSTypography.footnote())
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
            trailing
            if action != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(DSSpacing.md)
        .contentShape(Rectangle())
    }
}

#if DEBUG
private struct DSSettingsPreviewHost: View {
    @State private var haptics = true
    @State private var notifications = false

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            DSSettingsSection("Preferences") {
                DSSettingsRow(systemImage: "iphone.radiowaves.left.and.right",
                              iconColor: Color.accent,
                              title: "Haptics") {
                    Toggle("", isOn: $haptics).labelsHidden()
                }
                DSSettingsRow(systemImage: "bell.badge.fill",
                              iconColor: Color.warningHigh,
                              title: "Notifications",
                              showsDivider: false) {
                    Toggle("", isOn: $notifications).labelsHidden()
                }
            }
            DSSettingsSection("About", footer: "Version 1.0.0") {
                DSSettingsRow(systemImage: "envelope.fill",
                              iconColor: Color.accent,
                              title: "Contact support",
                              subtitle: "Get help by email",
                              action: {})
                DSSettingsRow(systemImage: "star.fill",
                              iconColor: Color.warningHigh,
                              title: "Rate the app",
                              showsDivider: false,
                              action: {})
            }
        }
        .padding(DSSpacing.lg)
        .background(Color.background)
    }
}

#Preview("Settings section") {
    DSSettingsPreviewHost()
}
#endif
