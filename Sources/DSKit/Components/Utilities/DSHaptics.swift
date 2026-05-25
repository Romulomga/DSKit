import UIKit

/// Thin facade over `UIFeedbackGenerator`. Every entry takes an `if enabled:`
/// gate so components can pipe the `\.dsHapticsEnabled` environment value
/// straight through, e.g. `DSHaptics.light(if: hapticsEnabled)`.
@MainActor
public enum DSHaptics {
    public static func light(if enabled: Bool = true) {
        guard enabled else { return }
        let g = UIImpactFeedbackGenerator(style: .light)
        g.prepare()
        g.impactOccurred()
    }

    public static func medium(if enabled: Bool = true) {
        guard enabled else { return }
        let g = UIImpactFeedbackGenerator(style: .medium)
        g.prepare()
        g.impactOccurred()
    }

    public static func success(if enabled: Bool = true) {
        guard enabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.success)
    }

    public static func warning(if enabled: Bool = true) {
        guard enabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.warning)
    }

    public static func error(if enabled: Bool = true) {
        guard enabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.error)
    }
}
