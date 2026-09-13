import SwiftUI
import UIKit

/// A "done" pill over numeric keyboards, which have no return key to dismiss them.
/// Drawn by the app over the keyboard (not the SwiftUI keyboard toolbar, which merges
/// the items of every field and does not refresh reliably), only while the focused
/// field's keyboard is numeric. Apply once per screen.
public enum DSKeyboardToolbar {
    /// The pill's title; nil uses the DSKit "Done" localization.
    nonisolated(unsafe) public static var doneTitle: LocalizedStringKey?

    @MainActor
    public static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public struct DSKeyboardDoneToolbar: ViewModifier {
    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var keyboard = DSKeyboardState()

    public init() {}

    public func body(content: Content) -> some View {
        content.overlay(alignment: .bottomTrailing) {
            if keyboard.isVisible, keyboard.isNumeric {
                Button(action: DSKeyboardToolbar.dismissKeyboard) {
                    Group {
                        if let title = DSKeyboardToolbar.doneTitle {
                            Text(title)
                        } else {
                            Text("Done", bundle: .dsKit)
                        }
                    }
                    .font(DSTypography.subheadline().bold())
                    .foregroundStyle(theme.primary)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.vertical, DSSpacing.sm)
                    .background(Color.surfaceElevated, in: Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                }
                .padding(DSSpacing.md)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? nil : DSMotion.short, value: keyboard.isVisible && keyboard.isNumeric)
    }
}

extension View {
    /// The screen's "done" pill over numeric keyboards. Apply once per screen, never per field.
    public func dsKeyboardDone() -> some View {
        modifier(DSKeyboardDoneToolbar())
    }
}
