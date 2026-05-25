import SwiftUI

/// Full-width filled button. Use for the dominant action on a screen
/// (one per screen, ideally).
public struct DSPrimaryButton: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let title: String
    private let systemImage: String?
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        systemImage: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button {
            DSHaptics.medium()
            action()
        } label: {
            HStack(spacing: DSSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .font(DSTypography.headline())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .padding(.horizontal, DSSpacing.lg)
            .background(theme.primary.opacity(isEnabled ? 1.0 : 0.5))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg, style: .continuous))
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(isLoading || !isEnabled)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
    }
}

/// Subtle scale-down on press, automatically suppressed when Reduce Motion is on.
/// Used by all DSKit button-like components.
struct DSPressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DSPressableLabel(configuration: configuration)
    }
}

private struct DSPressableLabel: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1.0)
            .animation(DSMotion.snappy, value: configuration.isPressed)
    }
}

#if DEBUG
#Preview("Primary button") {
    DSPreviewContainer("Primary") {
        VStack(spacing: DSSpacing.md) {
            DSPrimaryButton("Draw", systemImage: "sparkles") {}
            DSPrimaryButton("Loading", isLoading: true) {}
            DSPrimaryButton("Disabled") {}
                .disabled(true)
        }
    }
}

#Preview("Primary button — dark") {
    DSPreviewContainer("Primary") {
        DSPrimaryButton("Draw", systemImage: "sparkles") {}
    }
    .preferredColorScheme(.dark)
}
#endif
