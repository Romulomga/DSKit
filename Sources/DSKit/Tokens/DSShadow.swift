import SwiftUI

/// Very subtle shadow presets. Apple-like surfaces rely on materials and
/// borders far more than shadows — use these sparingly, mostly on
/// `DSCard(.elevated)` and floating overlays.
public struct DSShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public static let none = DSShadow(color: .clear, radius: 0)
    public static let subtle = DSShadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    public static let card = DSShadow(color: Color.black.opacity(0.06), radius: 10, y: 4)
    public static let floating = DSShadow(color: Color.black.opacity(0.10), radius: 16, y: 6)
}

public extension View {
    func dsShadow(_ shadow: DSShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
