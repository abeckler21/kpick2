//
//  ProjectDescriptionView.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/26/26.
//

// todo
import SwiftUI
import SwiftData
import PDFKit
// source: https://developer.apple.com/documentation/SwiftData/Defining-data-relationships-with-enumerations-and-model-classes
// source: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-define-swiftdata-models-using-the-model-macro

struct ProjectDescriptionView: View {
    @Bindable var project: Project
    // for voice recording increment function
    @State private var recognizer = SpeechRecognizer()
    @State private var showEditor = false
    // this is the line counter
    @State private var showLineCounter = false
    // use this to add patterns while app is running
    @Environment(\.modelContext) private var context
    let columns = [GridItem(.adaptive(minimum: 120), spacing: 20)]
    
    // build a remote pdf url only if this project has a pdf filename
    var rawPDFURL: URL? {
        guard let pdfFileName = project.pdfFileName else { return nil }
        return URL(string: "https://raw.githubusercontent.com/etanios03/knitpick-patterns/main/\(pdfFileName)")
    }
    
    var body: some View {
            VStack {
                Text(project.name)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                HStack {
                    Button() {
                        let newCounter = Counter(name: "Global")
                        project.counters.append(newCounter)
                    }
                    label: {
                        Label("Add Counter", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.title)
                    Button() {
                        showEditor = true
                    }
                    label: {
                        Label("Edit Counter", systemImage: "pencil")
                    }
                    Button() {
                        // start or stop audio recording
                        if recognizer.isRecording {
                            recognizer.stopRecording()
                        } else {
                            recognizer.startRecording()
                        }
                    }
                    label: {
                        Label("Audio", systemImage: "microphone")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.title)
                }
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Counters")
                        .font(.headline)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(project.counters) { counter in
                            CounterView(counter: counter)
                        }
                    }
                }
                .padding()
                .background(.title.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                
                // only show the pdf if this project has one
                if let pdfURL = rawPDFURL {
                    PDFRemoteView(url: pdfURL)
                        .frame(height: 350)
                        .padding(.horizontal)
                }
                
            }
            // hamburger menu for the line placeholder sheet
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLineCounter = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                CounterEditorView(project: project)
            }
            .sheet(isPresented: $showLineCounter) {
                LinePlaceHolderTableView()
            }
            .onChange(of: recognizer.nextCount) { oldValue, newValue in
                guard recognizer.isRecording else { return }

                if let counter = project.counters.first,
                   newValue > counter.count {
                    counter.count = newValue
                }
            }
            .onAppear {
                recognizer.requestPermissions()
            }
        .frame(maxWidth: .infinity)
    }
}
