//
//  ProjectEditorView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/8/26.
//


import SwiftUI
import SwiftData

struct ProjectEditorView: View {

    @Query var projects: [Project]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {

        NavigationStack {
            List {
                ForEach(projects) {
                    project in TextField( "Project name", text: Binding( get: { project.name }, set: { project.name = $0 } ) )
            }
                .onDelete(perform: deleteProjects) }
            .navigationTitle("Edit Projects")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            let project = projects[index]
            modelContext.delete(project)
        }
    }
}
