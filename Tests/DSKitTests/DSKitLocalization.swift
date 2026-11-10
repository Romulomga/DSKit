import Foundation
@testable import DSKit

enum DSKitLocalization {
    static let languages = ["ar", "de", "es", "fr", "it", "ja", "ko", "pt-BR", "zh-Hans"]

    /// The package's own translation of `key`, or `nil` when the language has none.
    static func translation(of key: String, in language: String) -> String? {
        guard
            let path = Bundle.dsKit.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else { return nil }

        let missing = "\u{1}"
        let value = bundle.localizedString(forKey: key, value: missing, table: nil)

        return value == missing ? nil : value
    }
}
