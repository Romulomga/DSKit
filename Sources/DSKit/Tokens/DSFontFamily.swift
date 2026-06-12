import Foundation

/// A custom font family for `DSTypography` tokens.
///
/// `name` is the font *family* name (e.g. "Nunito"), not a single face's
/// PostScript name — weights are resolved through `Font.weight(_:)`, so the
/// family should ship the weights the tokens use (regular, semibold, bold).
/// The host app is responsible for bundling and registering the font files
/// (`UIAppFonts` in Info.plist).
public struct DSFontFamily: Hashable, Sendable {
    public var name: String

    public init(_ name: String) {
        self.name = name
    }
}
