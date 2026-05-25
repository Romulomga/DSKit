import Foundation

extension Bundle {
    /// Public handle to the DSKit module bundle, so DSKit's own default
    /// `LocalizedStringKey` arguments can be resolved against the package's
    /// `Localizable.xcstrings` even when evaluated at the caller's site.
    public static var dsKit: Bundle { .module }
}
