//
//  ProjectDescriptionView.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/26/26.
//

// todo
import SwiftUI
import SwiftData
// source: https://developer.apple.com/documentation/SwiftData/Defining-data-relationships-with-enumerations-and-model-classes
// source: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-define-swiftdata-models-using-the-model-macro

struct ProjectDescriptionView: View {
    @Bindable var project: Project
    @State private var showEditor = false
    // use this to add patterns while app is running
    @Environment(\.modelContext) private var context
    // TODO: make a "pattern repeater remember" system so that you can mark what stitch you left off on and can pick up from there
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 20)]
    var body: some View {
        VStack {
            VStack {
                Text(project.name)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(project.counters) { counter in
                            CounterView(counter: counter)
                        }

                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                Button("Add Counter") {
                    let newCounter = Counter(name: "Global")
                    project.counters.append(newCounter)
                }
                Button("Edit Counters") {
                    showEditor = true
                }
            }
            .sheet(isPresented: $showEditor) {
                CounterEditorView(project: project)
            }
            HStack {
                LinePlaceHolderTableView()
            }
            Text("body")
            
        }
        .frame(maxWidth: .infinity)
    }
}
