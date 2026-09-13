import SwiftUI
import UIKit

/// One "done" bar over the keyboard per screen. SwiftUI merges the keyboard items of
/// every field in a hierarchy (two fields, two buttons) and does not refresh
/// conditional ones reliably, so the bar is declared once, where screens are built,
/// and its button resigns whatever is first responder.
public enum DSKeyboardToolbar {
    /// The button's title; nil uses the DSKit "Done" localization.
    nonisolated(unsafe) public static var doneTitle: LocalizedStringKey?

    @MainActor
    public static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public struct DSKeyboardDoneToolbar: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: DSKeyboardToolbar.dismissKeyboard) {
                    if let title = DSKeyboardToolbar.doneTitle {
                        Text(title).bold()
                    } else {
                        Text("Done", bundle: .dsKit).bold()
                    }
                }
            }
        }
    }
}

extension View {
    /// The screen's "done" bar over the keyboard. Apply once per screen, never per field.
    public func dsKeyboardDone() -> some View {
        modifier(DSKeyboardDoneToolbar())
    }
}
