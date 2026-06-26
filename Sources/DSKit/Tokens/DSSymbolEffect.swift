import SwiftUI

/// Discreet, purposeful SF Symbol feedback (WWDC23 *Animate symbols in your
/// app* / *Create animated symbols*), packaged so every app reaches for the
/// same restrained vocabulary instead of sprinkling ad-hoc effects.
///
/// The house style is "speed over spectacle": a single bounce to confirm an
/// action landed, Magic Replace to swap a symbol on a state change — never a
/// looping, attention-grabbing animation.
public extension View {
    /// One bounce when `value` changes — confirmation that an action landed
    /// (saved, shared, captured). Bind to a counter you bump on success:
    ///
    /// ```swift
    /// Image(systemName: "square.and.arrow.up")
    ///     .dsSymbolFeedback(shareCount)
    /// ```
    func dsSymbolFeedback(_ value: some Equatable) -> some View {
        symbolEffect(.bounce, value: value)
    }

    /// Magic Replace for a symbol that swaps with a state change (e.g. a status
    /// pill cycling pending → partial → paid). Pair with an animation keyed on
    /// the same state value so the swap reads as the state changing:
    ///
    /// ```swift
    /// Label(status.title, systemImage: status.symbol)
    ///     .dsSymbolStateReplace()
    ///     .animation(DSMotion.snappy, value: status)
    /// ```
    func dsSymbolStateReplace() -> some View {
        contentTransition(.symbolEffect(.replace))
    }
}
