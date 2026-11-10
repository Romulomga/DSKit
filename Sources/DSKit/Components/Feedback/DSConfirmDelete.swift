import SwiftUI

public extension DSAccessibilityID {
    static let deleteConfirm = "ds_delete_confirm"
    static let deleteCancel = "ds_delete_cancel"
}

private struct DSConfirmDeleteItemModifier<Item>: ViewModifier {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    @Binding var item: Item?
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let label: LocalizedStringKey
    let cancelLabel: LocalizedStringKey
    let perform: (Item) -> Void

    private var isPresented: Binding<Bool> {
        Binding(
            get: { item != nil },
            set: { presented in
                if !presented {
                    item = nil
                }
            }
        )
    }

    func body(content: Content) -> some View {
        content.alert(title, isPresented: isPresented, presenting: item) { pending in
            Button(role: .destructive) {
                DSHaptics.warning(if: hapticsEnabled)
                perform(pending)
                item = nil
            } label: {
                Text(label)
            }
            .accessibilityIdentifier(DSAccessibilityID.deleteConfirm)

            Button(role: .cancel) {
                item = nil
            } label: {
                Text(cancelLabel)
            }
            .accessibilityIdentifier(DSAccessibilityID.deleteCancel)
        } message: { _ in
            if let message {
                Text(message)
            }
        }
    }
}

private struct DSConfirmDeleteModifier: ViewModifier {
    @Environment(\.dsHapticsEnabled) private var hapticsEnabled

    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let label: LocalizedStringKey
    let cancelLabel: LocalizedStringKey
    let perform: () -> Void

    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isPresented) {
            Button(role: .destructive) {
                DSHaptics.warning(if: hapticsEnabled)
                perform()
            } label: {
                Text(label)
            }
            .accessibilityIdentifier(DSAccessibilityID.deleteConfirm)

            Button(role: .cancel) {
            } label: {
                Text(cancelLabel)
            }
            .accessibilityIdentifier(DSAccessibilityID.deleteCancel)
        } message: {
            if let message {
                Text(message)
            }
        }
    }
}

public extension View {
    /// Confirms a deletion in a centered alert. The trigger (a swipe action,
    /// a menu, a row button) stores what is leaving in `item`; the alert shows
    /// while there is one, hands it to `perform` on confirmation and clears it.
    ///
    /// A swipe action that opens this alert must not have the destructive
    /// role (`Button(role: .destructive)`): for that role iOS removes the row
    /// by itself, so on Cancel the row stays hidden and the list crashes on
    /// its next insert. Use a plain button with `.tint(.red)`.
    ///
    /// Confirming plays the warning haptic once: `perform` should not play
    /// another. `label` names what goes ("Delete client"). `cancelLabel`
    /// defaults to the package's "Cancel"; an app with languages the package
    /// lacks passes its own, looked up in the app's catalog.
    ///
    /// ```swift
    /// @State private var pendingDeletion: Client?
    ///
    /// List { ... }
    ///     .dsConfirmDelete(item: $pendingDeletion, title: "Delete this client?", label: "Delete client") { client in
    ///         repository.delete(client)
    ///     }
    /// ```
    func dsConfirmDelete<Item>(
        item: Binding<Item?>,
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        label: LocalizedStringKey,
        cancelLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Cancel", bundle: .dsKit)),
        perform: @escaping (Item) -> Void
    ) -> some View {
        modifier(
            DSConfirmDeleteItemModifier(
                item: item,
                title: title,
                message: message,
                label: label,
                cancelLabel: cancelLabel,
                perform: perform
            )
        )
    }

    /// The same confirmation for a delete button inside an editor, where
    /// there is no pending item to hold.
    func dsConfirmDelete(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        label: LocalizedStringKey,
        cancelLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Cancel", bundle: .dsKit)),
        perform: @escaping () -> Void
    ) -> some View {
        modifier(
            DSConfirmDeleteModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                label: label,
                cancelLabel: cancelLabel,
                perform: perform
            )
        )
    }
}

#if DEBUG
private struct DSConfirmDeletePreviewHost: View {
    @State private var clients = ["Ana Souza", "Bruno Lima", "Carla Dias"]
    @State private var pendingDeletion: String?

    var body: some View {
        List(clients, id: \.self) { client in
            Text(client)
                .swipeActions {
                    // No destructive role: iOS would take the row out before
                    // the alert is answered, and Cancel would leave it hidden.
                    Button {
                        pendingDeletion = client
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
        }
        .dsConfirmDelete(
            item: $pendingDeletion,
            title: "Delete this client?",
            message: "This can't be undone.",
            label: "Delete client"
        ) { client in
            clients.removeAll { $0 == client }
        }
    }
}

#Preview("Confirm delete") {
    DSConfirmDeletePreviewHost()
}
#endif
