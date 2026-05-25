#if DEBUG
import SwiftUI

struct NumberPickerScreenPreview: View {
    @State private var minimum: Int? = 1
    @State private var maximum: Int? = 100
    @State private var count: Int? = 1
    @State private var allowDuplicates = false

    var body: some View {
        DSScreen(
            title: "Numbers",
            subtitle: "Pick random integers from a range"
        ) {
            DSCard {
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    HStack(spacing: DSSpacing.md) {
                        DSNumberField(title: "Min", value: $minimum)
                        DSNumberField(title: "Max", value: $maximum)
                    }
                    DSNumberField(title: "How many", value: $count)
                    DSToggleRow(
                        "Allow duplicates",
                        subtitle: "Same number may appear more than once",
                        systemImage: "doc.on.doc",
                        isOn: $allowDuplicates
                    )
                }
            }
        } bottomAction: {
            DSPrimaryButton("Draw", systemImage: "sparkles") {}
        }
    }
}

#Preview("Number picker — light") {
    NumberPickerScreenPreview()
}

#Preview("Number picker — dark") {
    NumberPickerScreenPreview()
        .preferredColorScheme(.dark)
}
#endif
