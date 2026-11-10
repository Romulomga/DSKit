import SwiftUI

/// How the discard question is shown.
public enum DSDiscardPresentation: Sendable {
    /// `confirmationDialog`: the action sheet the system apps use when a
    /// modified sheet is cancelled. iOS 26 draws it as a popover anchored to
    /// the modified view.
    case dialog

    /// A centered `alert`, for screens where the anchored dialog misplaces
    /// itself (a list row, a toolbar that goes away).
    case alert
}

public extension DSAccessibilityID {
    static let discardConfirm = "ds_discard_confirm"
    static let discardKeepEditing = "ds_discard_keep_editing"
    static let discardBack = "ds_discard_back"
}

enum DSDiscardGuardLogic {
    /// Nothing counts as changed until the opening snapshot was taken.
    static func hasChanges<Snapshot: Equatable>(pristine: Snapshot?, current: Snapshot) -> Bool {
        guard let pristine else { return false }

        return pristine != current
    }
}

// MARK: - Question

private struct DSDiscardConfirmationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let discardLabel: LocalizedStringKey
    let keepEditingLabel: LocalizedStringKey
    let presentation: DSDiscardPresentation
    let onDiscard: () -> Void

    func body(content: Content) -> some View {
        switch presentation {
        case .dialog:
            content.confirmationDialog(title, isPresented: $isPresented, titleVisibility: .visible) {
                actions
            } message: {
                messageText
            }

        case .alert:
            content.alert(title, isPresented: $isPresented) {
                actions
            } message: {
                messageText
            }
        }
    }

    @ViewBuilder
    private var actions: some View {
        Button(role: .destructive, action: onDiscard) {
            Text(discardLabel)
        }
        .accessibilityIdentifier(DSAccessibilityID.discardConfirm)

        Button(role: .cancel) {
        } label: {
            Text(keepEditingLabel)
        }
        .accessibilityIdentifier(DSAccessibilityID.discardKeepEditing)
    }

    @ViewBuilder
    private var messageText: some View {
        if let message {
            Text(message)
        }
    }
}

// MARK: - Sheet guard

private struct DSDiscardGuardModifier: ViewModifier {
    let hasChanges: Bool
    @Binding var cancelRequested: Bool
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let discardLabel: LocalizedStringKey
    let keepEditingLabel: LocalizedStringKey
    let presentation: DSDiscardPresentation
    let onDiscard: () -> Void

    @State private var showsConfirmation = false

    func body(content: Content) -> some View {
        content
            .interactiveDismissDisabled(hasChanges)
            .onChange(of: cancelRequested) { _, requested in
                guard requested else { return }

                cancelRequested = false

                if hasChanges {
                    showsConfirmation = true
                } else {
                    onDiscard()
                }
            }
            .modifier(
                DSDiscardConfirmationModifier(
                    isPresented: $showsConfirmation,
                    title: title,
                    message: message,
                    discardLabel: discardLabel,
                    keepEditingLabel: keepEditingLabel,
                    presentation: presentation,
                    onDiscard: onDiscard
                )
            )
    }
}

private struct DSSnapshotDiscardGuardModifier<Snapshot: Equatable>: ViewModifier {
    let snapshot: Snapshot
    @Binding var cancelRequested: Bool
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let discardLabel: LocalizedStringKey
    let keepEditingLabel: LocalizedStringKey
    let presentation: DSDiscardPresentation
    let onDiscard: () -> Void

    @State private var pristine: Snapshot?
    @State private var isArmed = false

    func body(content: Content) -> some View {
        content
            // The task runs after the form's own `onAppear`, which may still
            // fill in starting values. It only arms: `onChange` then reads the
            // snapshot of the current render, not the one the task captured.
            .task {
                isArmed = true
            }
            .onChange(of: isArmed) {
                if pristine == nil {
                    pristine = snapshot
                }
            }
            .modifier(
                DSDiscardGuardModifier(
                    hasChanges: DSDiscardGuardLogic.hasChanges(pristine: pristine, current: snapshot),
                    cancelRequested: $cancelRequested,
                    title: title,
                    message: message,
                    discardLabel: discardLabel,
                    keepEditingLabel: keepEditingLabel,
                    presentation: presentation,
                    onDiscard: onDiscard
                )
            )
    }
}

// MARK: - Pushed screen guard

private struct DSBackDiscardGuardModifier: ViewModifier {
    let hasChanges: Bool
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let discardLabel: LocalizedStringKey
    let keepEditingLabel: LocalizedStringKey
    let backLabel: LocalizedStringKey
    let presentation: DSDiscardPresentation
    let onDiscard: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.isPresented) private var isPresented
    @State private var showsConfirmation = false

    /// At the root of a stack there is nowhere to go back to.
    private var isGuarding: Bool { isPresented && hasChanges }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(isGuarding)
            .toolbar {
                if isGuarding {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showsConfirmation = true
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                        .accessibilityLabel(Text(backLabel))
                        .accessibilityIdentifier(DSAccessibilityID.discardBack)
                    }
                }
            }
            .modifier(
                DSDiscardConfirmationModifier(
                    isPresented: $showsConfirmation,
                    title: title,
                    message: message,
                    discardLabel: discardLabel,
                    keepEditingLabel: keepEditingLabel,
                    presentation: presentation,
                    onDiscard: {
                        if let onDiscard {
                            onDiscard()
                        } else {
                            dismiss()
                        }
                    }
                )
            )
    }
}

// MARK: - API

public extension View {
    /// Guards an editing sheet against losing what was typed. The guard keeps
    /// the `snapshot` from when the sheet opened and compares it with the
    /// current one: unchanged, a cancel request calls `onDiscard` right away;
    /// changed, it asks first, and the swipe that closes the sheet is disabled.
    ///
    /// Wire the Cancel button to `cancelRequested = true`. `snapshot` must
    /// change whenever an editable field does.
    ///
    /// The texts default to the package's own translations. An app with
    /// languages the package lacks passes its own `title`, `discardLabel` and
    /// `keepEditingLabel`: a key given here is looked up in the app's catalog.
    ///
    /// ```swift
    /// @State private var cancelRequested = false
    ///
    /// Form { ... }
    ///     .toolbar {
    ///         ToolbarItem(placement: .cancellationAction) {
    ///             Button("Cancel") { cancelRequested = true }
    ///         }
    ///     }
    ///     .dsDiscardGuard([name, phone, notes], cancelRequested: $cancelRequested) { dismiss() }
    /// ```
    func dsDiscardGuard<Snapshot: Equatable>(
        _ snapshot: Snapshot,
        cancelRequested: Binding<Bool>,
        title: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard changes?", bundle: .dsKit)),
        message: LocalizedStringKey? = nil,
        discardLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard", bundle: .dsKit)),
        keepEditingLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Keep editing", bundle: .dsKit)),
        presentation: DSDiscardPresentation = .dialog,
        onDiscard: @escaping () -> Void
    ) -> some View {
        modifier(
            DSSnapshotDiscardGuardModifier(
                snapshot: snapshot,
                cancelRequested: cancelRequested,
                title: title,
                message: message,
                discardLabel: discardLabel,
                keepEditingLabel: keepEditingLabel,
                presentation: presentation,
                onDiscard: onDiscard
            )
        )
    }

    /// The same guard for a screen that already knows whether it changed
    /// (a model with its own `hasChanges`).
    func dsDiscardGuard(
        hasChanges: Bool,
        cancelRequested: Binding<Bool>,
        title: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard changes?", bundle: .dsKit)),
        message: LocalizedStringKey? = nil,
        discardLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard", bundle: .dsKit)),
        keepEditingLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Keep editing", bundle: .dsKit)),
        presentation: DSDiscardPresentation = .dialog,
        onDiscard: @escaping () -> Void
    ) -> some View {
        modifier(
            DSDiscardGuardModifier(
                hasChanges: hasChanges,
                cancelRequested: cancelRequested,
                title: title,
                message: message,
                discardLabel: discardLabel,
                keepEditingLabel: keepEditingLabel,
                presentation: presentation,
                onDiscard: onDiscard
            )
        )
    }

    /// Guards a pushed screen: while `hasChanges` is true the system back
    /// button (and its swipe) gives way to one that asks first. Discarding
    /// pops the screen unless `onDiscard` says otherwise. `backLabel` is what
    /// VoiceOver reads for that button.
    func dsBackDiscardGuard(
        hasChanges: Bool,
        title: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard changes?", bundle: .dsKit)),
        message: LocalizedStringKey? = nil,
        discardLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard", bundle: .dsKit)),
        keepEditingLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Keep editing", bundle: .dsKit)),
        backLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Back", bundle: .dsKit)),
        presentation: DSDiscardPresentation = .dialog,
        onDiscard: (() -> Void)? = nil
    ) -> some View {
        modifier(
            DSBackDiscardGuardModifier(
                hasChanges: hasChanges,
                title: title,
                message: message,
                discardLabel: discardLabel,
                keepEditingLabel: keepEditingLabel,
                backLabel: backLabel,
                presentation: presentation,
                onDiscard: onDiscard
            )
        )
    }

    /// Only the question, for a screen that decides by itself when to ask.
    func dsDiscardConfirmation(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard changes?", bundle: .dsKit)),
        message: LocalizedStringKey? = nil,
        discardLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Discard", bundle: .dsKit)),
        keepEditingLabel: LocalizedStringKey = LocalizedStringKey(String(localized: "Keep editing", bundle: .dsKit)),
        presentation: DSDiscardPresentation = .dialog,
        onDiscard: @escaping () -> Void
    ) -> some View {
        modifier(
            DSDiscardConfirmationModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                discardLabel: discardLabel,
                keepEditingLabel: keepEditingLabel,
                presentation: presentation,
                onDiscard: onDiscard
            )
        )
    }
}

#if DEBUG
private struct DSDiscardGuardPreviewHost: View {
    @State private var showsEditor = false

    var body: some View {
        DSPrimaryButton("Edit client") {
            showsEditor = true
        }
        .padding(DSSpacing.lg)
        .sheet(isPresented: $showsEditor) {
            DSDiscardGuardPreviewEditor()
        }
    }
}

private struct DSDiscardGuardPreviewEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "Ana Souza"
    @State private var cancelRequested = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            }
            .navigationTitle("Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        cancelRequested = true
                    }
                }
            }
            .dsDiscardGuard(name, cancelRequested: $cancelRequested) {
                dismiss()
            }
        }
    }
}

#Preview("Discard guard") {
    DSDiscardGuardPreviewHost()
}
#endif
