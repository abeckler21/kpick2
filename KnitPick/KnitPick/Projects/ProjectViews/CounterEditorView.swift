//
//  CounterEditorView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/7/26.
//

import SwiftUI
import SwiftData

struct CounterEditorView: View {

    @Bindable var project: Project
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {
            List {
                ForEach($project.counters) { $counter in
                    TextField("Counter name", text: $counter.name)
                }
                .onDelete(perform: deleteCounters)
                Button("Add Counter") {
                    project.counters.append(Counter(name: "New Counter"))
                }
            }
            .navigationTitle("Edit Counters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    func deleteCounters(at offsets: IndexSet) {
        project.counters.remove(atOffsets: offsets)
    }
}
