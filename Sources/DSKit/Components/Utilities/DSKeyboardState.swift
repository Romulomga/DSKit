import Combine
import SwiftUI
import UIKit

/// Whether the keyboard is on screen, how tall it is, and whether it is a numeric one
/// (number, decimal, phone pads have no return key). Read from the field that is
/// first responder when the keyboard comes up.
@MainActor
@Observable
public final class DSKeyboardState {
    public private(set) var isVisible = false
    public private(set) var height: CGFloat = 0
    public private(set) var isNumeric = false
    private var cancellables: Set<AnyCancellable> = []

    public static let numericKeyboards: Set<UIKeyboardType> = [.numberPad, .decimalPad, .phonePad, .asciiCapableNumberPad]

    public init() {
        let center = NotificationCenter.default
        center.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                self?.isVisible = true
                self?.height = frame?.height ?? 0
                self?.isNumeric = Self.firstResponderIsNumeric()
            }
            .store(in: &cancellables)
        center.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isVisible = false
                self?.height = 0
                self?.isNumeric = false
            }
            .store(in: &cancellables)
    }

    private static func firstResponderIsNumeric() -> Bool {
        guard let traits = UIResponder.dsCurrentFirstResponder as? UITextInputTraits else { return false }
        return numericKeyboards.contains(traits.keyboardType ?? .default)
    }
}

extension UIResponder {
    private static weak var reported: UIResponder?

    /// The responder that currently has the keyboard, found through the responder chain.
    public static var dsCurrentFirstResponder: UIResponder? {
        reported = nil
        UIApplication.shared.sendAction(#selector(dsReportFirstResponder), to: nil, from: nil, for: nil)
        return reported
    }

    @objc private func dsReportFirstResponder() {
        UIResponder.reported = self
    }
}
