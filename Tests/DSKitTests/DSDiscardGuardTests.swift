import Testing
@testable import DSKit

@Suite("Discard guard")
struct DSDiscardGuardTests {
    @Test func nothingChangedBeforeTheOpeningSnapshot() {
        #expect(!DSDiscardGuardLogic.hasChanges(pristine: nil, current: "Ana"))
    }

    @Test func sameSnapshotHasNoChanges() {
        #expect(!DSDiscardGuardLogic.hasChanges(pristine: ["Ana", "11"], current: ["Ana", "11"]))
    }

    @Test func differentSnapshotHasChanges() {
        #expect(DSDiscardGuardLogic.hasChanges(pristine: ["Ana", "11"], current: ["Ana", "12"]))
    }

    @Test func typingBackTheOriginalClearsTheChange() {
        let pristine = "Ana"
        var current = "Ana B"

        #expect(DSDiscardGuardLogic.hasChanges(pristine: pristine, current: current))

        current = "Ana"

        #expect(!DSDiscardGuardLogic.hasChanges(pristine: pristine, current: current))
    }

    @Test func dialogButtonsHaveDistinctIdentifiers() {
        let identifiers = [
            DSAccessibilityID.discardConfirm,
            DSAccessibilityID.discardKeepEditing,
            DSAccessibilityID.discardBack
        ]

        #expect(Set(identifiers).count == identifiers.count)
    }

    @Test(arguments: ["Discard changes?", "Discard", "Keep editing", "Back"])
    func stringsComeInEveryLanguage(key: String) {
        for language in DSKitLocalization.languages {
            #expect(DSKitLocalization.translation(of: key, in: language) != nil, "\(key) in \(language)")
        }
    }

    @Test func brazilianPortugueseWording() {
        #expect(DSKitLocalization.translation(of: "Discard changes?", in: "pt-BR") == "Descartar as alterações?")
        #expect(DSKitLocalization.translation(of: "Discard", in: "pt-BR") == "Descartar")
        #expect(DSKitLocalization.translation(of: "Keep editing", in: "pt-BR") == "Continuar editando")
    }
}
