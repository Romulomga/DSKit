import SwiftUI
import UIKit

/// Semantic colors backed by `UIColor` system colors. Use these so light/dark
/// mode and accessibility contrast settings are honored automatically.
public enum DSColor {
    public static let background = Color(uiColor: .systemBackground)
    public static let groupedBackground = Color(uiColor: .systemGroupedBackground)
    public static let surface = Color(uiColor: .secondarySystemBackground)
    public static let elevatedSurface = Color(uiColor: .tertiarySystemBackground)

    public static let primary = Color(uiColor: .systemBlue)
    public static let secondary = Color(uiColor: .systemIndigo)

    public static let textPrimary = Color(uiColor: .label)
    public static let textSecondary = Color(uiColor: .secondaryLabel)

    public static let border = Color(uiColor: .separator)

    public static let success = Color(uiColor: .systemGreen)
    public static let warning = Color(uiColor: .systemOrange)
    public static let error = Color(uiColor: .systemRed)
}
