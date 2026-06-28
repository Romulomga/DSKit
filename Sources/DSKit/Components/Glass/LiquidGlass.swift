import SwiftUI

/// **Liquid Glass material layer.** On iOS 26 (built with the iOS 26 SDK) this uses native
/// **Liquid Glass**; on iOS 17–18 it degrades gracefully. The design rules this file encapsulates —
/// so call sites don't repeat them:
///
/// - Glass **only on the navigation/action layer** that floats over content (tab bar, toolbars,
///   primary action). Content cards (`DSCard`) stay on the content layer — **never** glass on them.
/// - **Never glass-on-glass.** Over glass use fills/vibrancy, not another material layer.
/// - **Tint only on the primary action** — when everything is colored, nothing stands out.
/// - **Concentric corners** (`.continuous`) so the glass nests into the screen/window curvature.
public enum LiquidGlass {
    /// `true` on iOS 26+ — native material available (apps built with the iOS 26 SDK can still run
    /// from iOS 17, so this varies at runtime).
    public static var isAvailable: Bool {
        if #available(iOS 26.0, *) { return true }
        return false
    }
}

@available(iOS 26.0, *)
extension LiquidGlass {
    /// Builds the **Regular** `Glass` (the default — adaptive, works at any size over any content)
    /// with optional tint/interactivity.
    public static func style(tint: Color?, interactive: Bool) -> Glass {
        var glass: Glass = .regular

        if let tint {
            glass = glass.tint(tint)
        }

        if interactive {
            glass = glass.interactive()
        }

        return glass
    }
}

extension View {
    /// Material for a **floating** element (primary action, bar/control hovering over content).
    /// iOS 26: `glassEffect` Regular — adaptive, with lensing, optionally tinted and "interactive"
    /// (energizes with light on touch). iOS 17–18 fallback: a tinted fill (or thin material when
    /// untinted) + hairline + shadow, preserving the "raised, tappable surface" read.
    @ViewBuilder
    public func glassFloat<S: Shape>(
        tint: Color? = nil,
        interactive: Bool = true,
        in shape: S
    ) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(LiquidGlass.style(tint: tint, interactive: interactive), in: shape)
        } else {
            background {
                if let tint {
                    shape.fill(tint)
                } else {
                    shape.fill(.ultraThinMaterial)
                }
            }
            .overlay {
                shape.stroke(Color.white.opacity(0.14), lineWidth: 0.5)
            }
            .compositingGroup()
            .shadow(color: .black.opacity(0.16), radius: 12, y: 5)
        }
    }
}

/// Groups multiple floating glass elements so they **morph and merge** correctly (e.g. two action
/// buttons side by side in a bar). iOS 26: `GlassEffectContainer`. Below: passes the content
/// straight through (each `glassFloat` handles its own fallback).
public struct GlassGroup<Content: View>: View {
    private var spacing: CGFloat?
    private var content: () -> Content

    public init(spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content()
            }
        } else {
            content()
        }
    }
}

extension View {
    /// **Scroll edge effect "hard"**: a uniform separation between a pinned bar/accessory and the
    /// content scrolling beneath it. iOS 26 only; no-op below. Use when the default gradual fade
    /// doesn't give enough separation (e.g. a pinned header over a dense list).
    @ViewBuilder
    public func scrollEdgeHard(_ edges: Edge.Set = .top) -> some View {
        if #available(iOS 26.0, *) {
            scrollEdgeEffectStyle(.hard, for: edges)
        } else {
            self
        }
    }

    /// Tab bar that **shrinks on scroll down** (an iOS 26 hallmark: navigation yields space to
    /// content and returns on scroll up). iOS 26 only; no-op below. Apply to the `TabView`.
    @ViewBuilder
    public func glassTabBarMinimize() -> some View {
        if #available(iOS 26.0, *) {
            tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}
