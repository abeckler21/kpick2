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
    // pattern editor to make your own pattern if no pdf visible
    @State private var showPatternEditor = false
    // for voice recording increment function
    @State private var recognizer = SpeechRecognizer()
    @State private var showEditor = false
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
            
            /*// only show the pdf if this project has one
             if let pdfURL = rawPDFURL {
             PDFRemoteView(url: pdfURL)
             .frame(height: 350)
             .padding(.horizontal)
             }
             }*/
            // MARK: PATTERN PDF DISPLAY
            if let pdfURL = rawPDFURL {
                PDFRemoteView(url: pdfURL)
                    .frame(height: 350)
                    .padding(.horizontal)
                
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pattern")
                        .font(.headline)
                    
                    if showPatternEditor || project.patternText != nil {
                        // source: https://www.appcoda.com/learnswiftui/swiftui-texteditor.html
                        // source: https://dev.to/simrandotdev/swiftui-fix-cannot-convert-bindingstring-to-binding-in-textfield-5h5f#:~:text=Aug%2012%2C%202025-,SwiftUI%20Fix:%20Cannot%20Convert%20Binding%20to%20Binding,empty%20string%20if%20it's%20nil.
                        TextEditor(
                            text: Binding(
                                get: { project.patternText ?? "" },
                                set: { project.patternText = $0 }
                            )
                        )
                        .frame(minHeight: 200)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    } else {
                        
                        Button {
                            showPatternEditor = true
                        } label: {
                            Label("Add Pattern", systemImage: "text.badge.plus")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.title)
                        
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showEditor) {
            CounterEditorView(project: project)
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
