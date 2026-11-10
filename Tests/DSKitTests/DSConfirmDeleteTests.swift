import SwiftUI
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

    @Test func defaultCancelResolvesInThePackageBundle() {
        let resolved = String(localized: "Cancel", bundle: .dsKit)

        #expect(DSKitLocalization.wordings(of: "Cancel").contains(resolved))
    }

    @MainActor
    @Test func cancelLabelIsOptionalAtEveryCallSite() {
        let pending = Binding<String?>.constant(nil)
        let flag = Binding.constant(false)

        _ = Color.clear.dsConfirmDelete(item: pending, title: "Delete?", label: "Delete") { _ in }
        _ = Color.clear.dsConfirmDelete(item: pending, title: "Delete?", message: "Gone.", label: "Delete", cancelLabel: "Keep") { _ in }

        _ = Color.clear.dsConfirmDelete(isPresented: flag, title: "Delete?", label: "Delete") {}
        _ = Color.clear.dsConfirmDelete(isPresented: flag, title: "Delete?", label: "Delete", cancelLabel: "Keep") {}
    }
}
