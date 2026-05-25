#if DEBUG
import SwiftUI

struct NamePickerScreenPreview: View {
    @State private var names = "Ana\nBruno\nCarla\nDiego\nEva\nFernanda"
    @State private var mode: String = "single"

    var body: some View {
        DSScreen(
            title: "Name Picker",
            subtitle: "Add names and pick a winner"
        ) {
            DSSegmentedPicker("Mode", selection: $mode, options: [
                DSSegmentedOption("single", label: "Single"),
                DSSegmentedOption("list", label: "List"),
                DSSegmentedOption("teams", label: "Teams")
            ])

            DSListInput(
                title: "Participants",
                text: $names,
                helperText: "One per line. Duplicates are kept on purpose."
            )
        } bottomAction: {
            DSPrimaryButton("Pick winner", systemImage: "sparkles") {}
        }
    }
}

#Preview("Name picker — light") {
    NamePickerScreenPreview()
}

#Preview("Name picker — dark") {
    NamePickerScreenPreview()
        .preferredColorScheme(.dark)
}
#endif
