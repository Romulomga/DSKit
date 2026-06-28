import SwiftUI

/// Full-bleed background composing a gradient + blurred halos for depth (a fake mesh gradient on
/// iOS 17). `.subtle` is the paywall intensity. Reusable across apps.
public struct AtmosphericBackground: View {
    private let tint: Color
    private var intensity: Intensity
    /// When `nil`, the secondary halo also uses `tint` (monochromatic).
    private var accent: Color?

    public enum Intensity: Sendable {
        case subtle, medium

        var topOpacity: Double {
            switch self { case .subtle: 0.10; case .medium: 0.20 }
        }
        var haloOpacity: Double {
            switch self { case .subtle: 0.20; case .medium: 0.32 }
        }
        var haloBlur: CGFloat {
            switch self { case .subtle: 60; case .medium: 90 }
        }
        var haloScale: CGFloat {
            switch self { case .subtle: 0.7; case .medium: 1.0 }
        }
    }

    public init(tint: Color, intensity: Intensity = .medium, accent: Color? = nil) {
        self.tint = tint
        self.intensity = intensity
        self.accent = accent
    }

    private var secondaryHaloColor: Color { accent ?? tint }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    tint.opacity(intensity.topOpacity),
                    tint.opacity(intensity.topOpacity * 0.2),
                    Color.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            GeometryReader { geo in
                ZStack {
                    Ellipse()
                        .fill(tint)
                        .frame(width: geo.size.width * intensity.haloScale, height: geo.size.height * 0.5 * intensity.haloScale)
                        .blur(radius: intensity.haloBlur)
                        .opacity(intensity.haloOpacity)
                        .offset(x: -geo.size.width * 0.15, y: -geo.size.height * 0.2)

                    Ellipse()
                        .fill(secondaryHaloColor)
                        .frame(width: geo.size.width * 0.8 * intensity.haloScale, height: geo.size.height * 0.4 * intensity.haloScale)
                        .blur(radius: intensity.haloBlur)
                        .opacity(intensity.haloOpacity * 0.55)
                        .offset(x: geo.size.width * 0.25, y: geo.size.height * 0.35)
                }
            }
        }
        .ignoresSafeArea()
    }
}
