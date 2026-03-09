//
//  MyProjectsView.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/28/26.
//

import SwiftUI
import SwiftData


// View to show all existing projects as a list
// user can add, delete and rename projects
struct MyProjectsView: View {
    // query in order to access the Project Model in the app data
    @Query var projects: [Project]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    // show the project name/delete editor sheet
    @State var showEditor: Bool = false
    var body: some View {
        NavigationStack {
            // Buttons to add or edit projects
            HStack {
                Button() {
                    let newProject = Project(name: "New Project", counters: [Counter(name: "Global")])
                    context.insert(newProject)
                }
                label: {
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(.title)
                Button() {
                    showEditor = true
                }
                label: {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.borderedProminent)
                .tint(.title)
            }
            // show project rows in a table format
            List {
                ForEach(projects) { item in
                    NavigationLink(value: item) {
                        ProjectRowView(project: item)
                    }
                }
                // when swiped to delete, remove a project
                .onDelete(perform: deleteProjects)
            }
            .navigationTitle("My Projects")
            // destination when clicked is to the projectDescriptionView for the specific project
            .navigationDestination(for: Project.self) { proj in ProjectDescriptionView(project: proj)
            }
        }
        // for swipe to delete 
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        // starter projects when app is first loaded
        .onAppear {
            addStarterProjects()
        }
        // edit and delete existing projects sheet
        .sheet(isPresented: $showEditor) {
            ProjectEditorView()
        }
    }
    // delete given project using the index of the project that was tapped
    func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            context.delete(projects[index])
        }
    }
    // when app is first loaded, put in these "starter" projects as examples
    func addStarterProjects() {
        if projects.isEmpty {
            let starters = [
                Project(name: "Chunky Scarf", counters: [Counter(name: "Global")]),
                Project(name: "Cable Knit Sweater", counters: [Counter(name: "Global")]),
                Project(name: "Beginner Beanie", counters: [Counter(name: "Global")])
            ]
            
            for project in starters {
                context.insert(project)
            }
        }
    }
    
}
