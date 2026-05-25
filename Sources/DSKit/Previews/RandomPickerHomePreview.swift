#if DEBUG
import SwiftUI

/// Composite preview — example home screen of a "Random Picker" utility app.
struct RandomPickerHomePreview: View {
    var body: some View {
        DSScreen(
            title: "Random",
            subtitle: "Pick numbers, names or teams"
        ) {
            DSIconButton(systemImage: "gearshape", style: .plain, accessibilityLabel: "Settings") {}
        } content: {
            DSSection("Pickers") {
                DSFeatureCard(
                    title: "Number Picker",
                    description: "Random integers from a range.",
                    systemImage: "number"
                ) {}
                DSFeatureCard(
                    title: "Name Picker",
                    description: "Draw one winner from a list.",
                    systemImage: "person.2.fill",
                    badge: "NEW"
                ) {}
                DSFeatureCard(
                    title: "Teams",
                    description: "Split names into balanced teams.",
                    systemImage: "person.3.fill"
                ) {}
                DSFeatureCard(
                    title: "Wheel",
                    description: "Spin a roulette wheel.",
                    systemImage: "circle.grid.cross.fill",
                    badge: "PRO",
                    isLocked: true
                ) {}
            }

            DSSection("Tools") {
                DSFeatureCard(
                    title: "Dice",
                    description: "Roll 1–10 dice with any sides.",
                    systemImage: "die.face.5.fill"
                ) {}
                DSFeatureCard(
                    title: "Coin Flip",
                    description: "Heads or tails.",
                    systemImage: "circle.lefthalf.filled"
                ) {}
            }
        }
    }
}

#Preview("Home — light") {
    RandomPickerHomePreview()
}

#Preview("Home — dark") {
    RandomPickerHomePreview()
        .preferredColorScheme(.dark)
}

#Preview("Home — XXL Dynamic Type") {
    RandomPickerHomePreview()
        .dynamicTypeSize(.accessibility2)
}
#endif
