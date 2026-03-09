//
//  CounterEditorView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/7/26.
//

import SwiftUI
import SwiftData

// View of sheet to edit counter names and delete counters for an existing Project
struct CounterEditorView: View {

    @Bindable var project: Project
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {
            List {
                // list each counter and its name
                ForEach($project.counters) { $counter in
                    TextField("Counter name", text: $counter.name)
                }
                // swipe to delete the counter
                .onDelete(perform: deleteCounters)
                Button("Add Counter") {
                    // create new counter using Counter class
                    project.counters.append(Counter(name: "New Counter"))
                }
            }
            .navigationTitle("Edit Counters")
            // Done button dismisses the sheet view
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    // delete Counter by removing from the Counter list in the associated Project class
    func deleteCounters(at offsets: IndexSet) {
        project.counters.remove(atOffsets: offsets)
    }
}
