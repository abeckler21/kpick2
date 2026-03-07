//
//  MyProjectsView.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/28/26.
//

import SwiftUI
import SwiftData


struct MyProjectsView: View {
    @Query var projects: [Project]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { item in
                    NavigationLink(value: item) {
                        ProjectRow(project: item)
                    }
                }
                // when swiped to delete, remove a project
                .onDelete(perform: deleteProjects)
            }
            .navigationTitle("My Projects")
            .navigationDestination(for: Project.self) { proj in ProjectDescriptionView(project: proj)
            }
            Button("Add Project") {
                let newProject = Project(name: "New Project", counters: [Counter(name: "Global")])
                context.insert(newProject)
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
        .onAppear {
            addStarterProjects()
        }
    }
    
    func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            context.delete(projects[index])
        }
    }
    // if there are no projects added by the user, put in these projects
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
