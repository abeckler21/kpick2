//
//  ProjectEditorView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/8/26.
//


import SwiftUI
import SwiftData

// View to show a table of existing projects, and allow user to edit names and delete them
struct ProjectEditorView: View {
    // access the projects list
    @Query var projects: [Project]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {

        NavigationStack {
            // show each project in a table
            List {
                ForEach(projects) {
                    project in TextField( "Project name", text: Binding( get: { project.name }, set: { project.name = $0 } ) )
            }
            .onDelete(perform: deleteProjects) }
            .navigationTitle("Edit Projects")
            // Done button to swipe out of sheet
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    // delete project using the index of the project that was swiped on
    func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            let project = projects[index]
            modelContext.delete(project)
        }
    }
}
