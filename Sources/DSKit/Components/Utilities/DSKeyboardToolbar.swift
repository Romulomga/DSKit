import UIKit

/// A "done" bar over numeric keyboards, which have no return key to dismiss them.
/// Installed once per process: it listens to every text field and text view that
/// begins editing (SwiftUI ones included) and, when the keyboard has no return key,
/// gives it an accessory bar whose button resigns the first responder.
@MainActor
public enum DSKeyboardToolbar {
    private static var observers: [any NSObjectProtocol] = []
    private static var title = "OK"

    /// Numeric keyboards: no return key of their own.
    public static let keyboardTypes: Set<UIKeyboardType> = [.numberPad, .decimalPad, .phonePad, .asciiCapableNumberPad]

    public static func install(doneTitle: String = "OK") {
        guard observers.isEmpty else { return }
        title = doneTitle
        let center = NotificationCenter.default
        observers = [
            center.addObserver(forName: UITextField.textDidBeginEditingNotification, object: nil, queue: .main) { notification in
                MainActor.assumeIsolated { attach(to: notification.object as? UITextField) }
            },
            center.addObserver(forName: UITextView.textDidBeginEditingNotification, object: nil, queue: .main) { notification in
                MainActor.assumeIsolated { attach(to: notification.object as? UITextView) }
            }
        ]
    }

    private static func attach(to input: (UIView & UITextInputTraits)?) {
        guard let input, keyboardTypes.contains(input.keyboardType ?? .default) else { return }
        if let field = input as? UITextField, field.inputAccessoryView == nil {
            field.inputAccessoryView = makeToolbar()
            field.reloadInputViews()
        } else if let view = input as? UITextView, view.inputAccessoryView == nil {
            view.inputAccessoryView = makeToolbar()
            view.reloadInputViews()
        }
    }

    private static func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let done = UIBarButtonItem(title: title, style: .done, target: DismissTarget.shared, action: #selector(DismissTarget.dismiss))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
        toolbar.sizeToFit()
        return toolbar
    }

    private final class DismissTarget: NSObject {
        static let shared = DismissTarget()

        @objc func dismiss() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
