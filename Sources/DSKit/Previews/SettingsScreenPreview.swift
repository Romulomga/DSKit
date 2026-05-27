#if DEBUG
import SwiftUI

struct SettingsScreenPreview: View {
    @State private var haptics = true
    @State private var sound = false
    @State private var notifications = true

    var body: some View {
        DSScreen(title: "Settings") {
            DSSettingsSection("Preferences") {
                DSSettingsRow(
                    systemImage: "iphone.radiowaves.left.and.right",
                    iconColor: Color.accent,
                    title: "Haptics"
                ) {
                    Toggle("", isOn: $haptics).labelsHidden()
                }
                DSSettingsRow(
                    systemImage: "speaker.wave.2.fill",
                    iconColor: Color.accent,
                    title: "Sound"
                ) {
                    Toggle("", isOn: $sound).labelsHidden()
                }
                DSSettingsRow(
                    systemImage: "bell.badge.fill",
                    iconColor: Color.warningHigh,
                    title: "Notifications"
                ) {
                    Toggle("", isOn: $notifications).labelsHidden()
                }
            }

            DSSettingsSection("Support", footer: "We usually answer in 1 business day.") {
                DSSettingsRow(
                    systemImage: "envelope.fill",
                    iconColor: Color.accent,
                    title: "Contact support",
                    subtitle: "Get help by email",
                    action: {}
                )
                DSSettingsRow(
                    systemImage: "star.fill",
                    iconColor: Color.warningHigh,
                    title: "Rate the app",
                    action: {}
                )
                DSSettingsRow(
                    systemImage: "doc.text.fill",
                    iconColor: .gray,
                    title: "Privacy policy",
                    action: {}
                )
            }
        }
    }
}

#Preview("Settings — light") {
    SettingsScreenPreview()
}

#Preview("Settings — dark") {
    SettingsScreenPreview()
        .preferredColorScheme(.dark)
}
#endif
