import SwiftUI

/// Lightweight snackbar/toast. Use directly inside an overlay, or apply the
/// `.dsToast(_:)` view modifier with a `Binding<DSToastMessage?>` for
/// automatic auto-dismiss.
public struct DSToast: View {
    public enum Style: Sendable, Equatable { case info, success, error, warning }

    private let message: LocalizedStringKey
    private let systemImage: String?
    private let style: Style

    public init(_ message: LocalizedStringKey, systemImage: String? = nil, style: Style = .info) {
        self.message = message
        self.systemImage = systemImage
        self.style = style
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: systemImage ?? defaultSymbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
            Text(message)
                .font(DSTypography.subheadline().weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm + 2)
        .background(tint, in: Capsule(style: .continuous))
        .dsShadow(.subtle)
        .accessibilityElement(children: .combine)
    }

    private var defaultSymbol: String {
        switch style {
        case .info: "info.circle.fill"
        case .success: "checkmark.circle.fill"
        case .error: "exclamationmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        }
    }

    private var tint: Color {
        switch style {
        case .info: Color.accent
        case .success: Color.successHigh
        case .error: Color.errorHigh
        case .warning: Color.warningHigh
        }
    }
}

/// Data describing a toast — wrap in `Binding<DSToastMessage?>` and pass to
/// `.dsToast(_:)`.
public struct DSToastMessage: Equatable {
    public let message: LocalizedStringKey
    public let systemImage: String?
    public let style: DSToast.Style

    public init(_ message: LocalizedStringKey, systemImage: String? = nil, style: DSToast.Style = .info) {
        self.message = message
        self.systemImage = systemImage
        self.style = style
    }
}

public extension View {
    /// Show a toast at the top safe area. Auto-dismisses after `duration`.
    func dsToast(_ toast: Binding<DSToastMessage?>, duration: TimeInterval = 2.0) -> some View {
        modifier(DSToastModifier(toast: toast, duration: duration))
    }
}

private struct DSToastModifier: ViewModifier {
    @Binding var toast: DSToastMessage?
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast {
                    DSToast(toast.message, systemImage: toast.systemImage, style: toast.style)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.md)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .task(id: toast) {
                            try? await Task.sleep(for: .seconds(duration))
                            withAnimation(DSMotion.medium) {
                                self.toast = nil
                            }
                        }
                }
            }
            .animation(DSMotion.spring, value: toast)
    }
}

#if DEBUG
private struct DSToastPreviewHost: View {
    @State private var toast: DSToastMessage? = DSToastMessage("Copied to clipboard", style: .success)

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSToast("Info notice", style: .info)
            DSToast("Saved successfully", style: .success)
            DSToast("Something went wrong", style: .error)
            DSToast("Heads up", style: .warning)

            DSSecondaryButton("Show toast") {
                toast = DSToastMessage("Copied to clipboard", style: .success)
            }
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.background)
        .dsToast($toast)
    }
}

#Preview("Toast") {
    DSToastPreviewHost()
}
#endif
