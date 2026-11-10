import SwiftUI
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

    /// The defaults of `keepEditingLabel` and `backLabel` are resolved in the
    /// package's bundle before they become a key, whatever the device language.
    @Test(arguments: ["Keep editing", "Back"])
    func defaultLabelResolvesInThePackageBundle(key: String) {
        let resolved = String(localized: String.LocalizationValue(key), bundle: .dsKit)

        #expect(DSKitLocalization.wordings(of: key).contains(resolved))
    }

    @MainActor
    @Test func labelsAreOptionalAtEveryCallSite() {
        let flag = Binding.constant(false)

        _ = Color.clear.dsDiscardGuard("Ana", cancelRequested: flag) {}
        _ = Color.clear.dsDiscardGuard("Ana", cancelRequested: flag, keepEditingLabel: "Continue") {}

        _ = Color.clear.dsDiscardGuard(hasChanges: true, cancelRequested: flag) {}
        _ = Color.clear.dsDiscardGuard(hasChanges: true, cancelRequested: flag, discardLabel: "Drop", keepEditingLabel: "Continue", presentation: .alert) {}

        _ = Color.clear.dsBackDiscardGuard(hasChanges: true)
        _ = Color.clear.dsBackDiscardGuard(hasChanges: true, keepEditingLabel: "Continue", backLabel: "Previous")

        _ = Color.clear.dsDiscardConfirmation(isPresented: flag) {}
        _ = Color.clear.dsDiscardConfirmation(isPresented: flag, keepEditingLabel: LocalizedStringKey("Continue")) {}
    }
}
