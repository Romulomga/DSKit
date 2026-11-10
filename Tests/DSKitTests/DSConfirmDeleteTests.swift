import Testing
@testable import DSKit

@Suite("Confirm delete")
struct DSConfirmDeleteTests {
    @Test func alertButtonsHaveDistinctIdentifiers() {
        #expect(DSAccessibilityID.deleteConfirm != DSAccessibilityID.deleteCancel)
    }

    @Test func cancelComesInEveryLanguage() {
        for language in DSKitLocalization.languages {
            #expect(DSKitLocalization.translation(of: "Cancel", in: language) != nil, "Cancel in \(language)")
        }

        #expect(DSKitLocalization.translation(of: "Cancel", in: "pt-BR") == "Cancelar")
    }
}
