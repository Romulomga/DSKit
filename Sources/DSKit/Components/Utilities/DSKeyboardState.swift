import Combine
import SwiftUI
import UIKit

/// Whether the keyboard is on screen, for layouts that must give way to it
/// (a bottom action that would otherwise cover the focused field).
@MainActor
@Observable
public final class DSKeyboardState {
    public private(set) var isVisible = false
    public private(set) var height: CGFloat = 0
    private var cancellables: Set<AnyCancellable> = []

    public init() {
        let center = NotificationCenter.default
        center.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                self?.isVisible = true
                self?.height = frame?.height ?? 0
            }
            .store(in: &cancellables)
        center.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isVisible = false
                self?.height = 0
            }
            .store(in: &cancellables)
    }
}
