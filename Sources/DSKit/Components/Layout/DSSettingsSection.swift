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
            .background(DSColor.surface)
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
        Button {
            guard let action else { return }
            DSHaptics.light(if: hapticsEnabled)
            action()
        } label: {
            HStack(spacing: DSSpacing.md) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(iconColor ?? DSColor.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(DSTypography.body())
                        .foregroundStyle(DSColor.textPrimary)
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
        .buttonStyle(.plain)
        .disabled(action == nil)
        .overlay(alignment: .bottom) {
            if showsDivider {
                Rectangle()
                    .fill(DSColor.border)
                    .frame(height: 0.5)
                    .padding(.leading, DSSpacing.md + 28 + DSSpacing.md)
            }
        }
        .accessibilityElement(children: .combine)
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
                              iconColor: DSColor.primary,
                              title: "Haptics") {
                    Toggle("", isOn: $haptics).labelsHidden()
                }
                DSSettingsRow(systemImage: "bell.badge.fill",
                              iconColor: DSColor.warning,
                              title: "Notifications",
                              showsDivider: false) {
                    Toggle("", isOn: $notifications).labelsHidden()
                }
            }
            DSSettingsSection("About", footer: "Version 1.0.0") {
                DSSettingsRow(systemImage: "envelope.fill",
                              iconColor: DSColor.secondary,
                              title: "Contact support",
                              subtitle: "Get help by email",
                              action: {})
                DSSettingsRow(systemImage: "star.fill",
                              iconColor: DSColor.warning,
                              title: "Rate the app",
                              showsDivider: false,
                              action: {})
            }
        }
        .padding(DSSpacing.lg)
        .background(DSColor.groupedBackground)
    }
}

#Preview("Settings section") {
    DSSettingsPreviewHost()
}
#endif
