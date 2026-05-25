import SwiftUI

/// Standard animation curves. Keep motion short and snappy — Apple's stock
/// UI rarely uses long durations.
public enum DSMotion {
    public static let short: Animation = .easeInOut(duration: 0.18)
    public static let medium: Animation = .easeInOut(duration: 0.28)
    public static let spring: Animation = .spring(response: 0.36, dampingFraction: 0.78)
    public static let snappy: Animation = .interactiveSpring(response: 0.28, dampingFraction: 0.88)
}
