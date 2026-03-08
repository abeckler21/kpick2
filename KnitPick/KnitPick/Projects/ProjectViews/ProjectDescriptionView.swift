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
    // for the audio button
    @State private var audioIsSelected = false
    // for voice recording increment function
    @State private var recognizer = SpeechRecognizer()
    @State private var showEditor = false
    // this is the line counter
    @State private var showLineCounter = false
    // use this to add patterns while app is running
    @Environment(\.modelContext) private var context
    
    // counter picker for audio button
    @State private var showCounterPicker = false
    @State private var selectedCounter: Counter?
    
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-position-views-in-a-grid-using-lazyvgrid-and-lazyhgrid
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 5)]
    
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
                Buttons
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Counters")
                        .font(.headline)
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(project.counters) { counter in
                                CounterView(counter: counter)
                            }
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
            .sheet(isPresented: $showCounterPicker) {
                CounterPickerView(
                    counters: project.counters,
                    selectedCounter: $selectedCounter
                )
            }
            .onChange(of: selectedCounter) { oldValue, newValue in
                guard newValue != nil else { return }

                audioIsSelected = true
                recognizer.startRecording()
            }
            .onChange(of: recognizer.nextCount) { oldValue, newValue in
                guard recognizer.isRecording else { return }

                guard let counter = selectedCounter else {return}
                if newValue > counter.count {
                    counter.count = newValue
                }
            }
            .onAppear {
                recognizer.requestPermissions()
            }
        .frame(maxWidth: .infinity)
    }
}

// private extension since too complex for the compiler
private extension ProjectDescriptionView {
    var Buttons: some View {
        HStack {
            Button() {
                let newCounter = Counter(name: "Global")
                project.counters.append(newCounter)
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
            Button() {
                if recognizer.isRecording {
                        recognizer.stopRecording()
                        audioIsSelected = false
                        selectedCounter = nil
                    } else {
                        showCounterPicker = true
                    }
            }
            label: {
                Label("Audio", systemImage: "microphone")
            }
            .buttonStyle(.borderedProminent)
            .tint(audioIsSelected ? .accent : .title)
        }
    }
}
