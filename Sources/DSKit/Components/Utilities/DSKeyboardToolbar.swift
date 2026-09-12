import SwiftUI

/// A "done" bar over keyboards that have no return key (number, decimal, phone pads).
/// SwiftUI text fields own their accessory view, so the bar goes through the
/// keyboard toolbar placement: `DSTextField` and `DSNumberField` add it on their own
/// when the keyboard needs it; custom fields call `dsKeyboardDone(isActive:dismiss:)`.
public enum DSKeyboardToolbar {
    /// Keyboards with no return key of their own.
    public static let keyboardTypes: Set<UIKeyboardType> = [.numberPad, .decimalPad, .phonePad, .asciiCapableNumberPad]

    /// The button's title; nil uses the DSKit "Done" localization.
    nonisolated(unsafe) public static var doneTitle: LocalizedStringKey?

    public static func needsDoneButton(_ keyboardType: UIKeyboardType) -> Bool {
        keyboardTypes.contains(keyboardType)
    }
}

/// The bar itself, shown while `isActive` (the field has focus).
public struct DSKeyboardDoneToolbar: ViewModifier {
    private let isActive: Bool
    private let dismiss: () -> Void

    public init(isActive: Bool, dismiss: @escaping () -> Void) {
        self.isActive = isActive
        self.dismiss = dismiss
    }

    public func body(content: Content) -> some View {
        content.toolbar {
            if isActive {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: dismiss) {
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
}

extension View {
    /// "Done" over the keyboard while `isActive`; `dismiss` should drop the field's focus.
    public func dsKeyboardDone(isActive: Bool, dismiss: @escaping () -> Void) -> some View {
        modifier(DSKeyboardDoneToolbar(isActive: isActive, dismiss: dismiss))
    }
}
