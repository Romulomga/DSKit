#if DEBUG
import SwiftUI

struct ResultScreenPreview: View {
    var body: some View {
        DSScreen(
            title: "Result"
        ) {
            DSResultCard(
                title: "Winner",
                primaryResult: "Ana",
                subtitle: "Picked from 12 participants"
            )

            DSResultCard(
                title: "Top 3",
                results: ["Ana", "Bruno", "Carla"],
                subtitle: "Out of 12"
            )

            HStack(spacing: DSSpacing.md) {
                DSSecondaryButton("Share", systemImage: "square.and.arrow.up") {}
                DSSecondaryButton("Copy", systemImage: "doc.on.doc") {}
            }
        } bottomAction: {
            DSPrimaryButton("Draw again", systemImage: "arrow.clockwise") {}
        }
    }
}

#Preview("Result — light") {
    ResultScreenPreview()
}

#Preview("Result — dark") {
    ResultScreenPreview()
        .preferredColorScheme(.dark)
}

#Preview("Result — XL Dynamic Type") {
    ResultScreenPreview()
        .dynamicTypeSize(.accessibility1)
}
#endif
