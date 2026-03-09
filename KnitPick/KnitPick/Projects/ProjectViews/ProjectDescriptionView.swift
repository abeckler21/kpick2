//
//  ProjectDescriptionView.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/26/26.
//


import SwiftUI
import SwiftData
import PDFKit
// source: https://developer.apple.com/documentation/SwiftData/Defining-data-relationships-with-enumerations-and-model-classes
// source: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-define-swiftdata-models-using-the-model-macro

// View that shows detailed project information: counters, patterns, and project notes
struct ProjectDescriptionView: View {
    @Bindable var project: Project
    // for the audio button
    @State private var audioIsSelected = false
    // pattern editor to make your own pattern if no pdf visible
    @State private var showPatternEditor = false
    // for voice recording increment function
    @State private var recognizer = SpeechRecognizer()
    // show editor for audio
    @State private var showEditor = false
    // var to see if the text field is active
    @FocusState private var isFocusedTextField: Bool
    // use this to add patterns while app is running
    @Environment(\.modelContext) private var context
    
    // counter picker for audio button
    @State private var showCounterPicker = false
    // selected counter for the Audio function
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
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color("TitleColor"))
            // MARK: COUNTER DISPLAY
            Buttons
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 16) {
                Text("Counters")
                    .font(.headline)
                // scroll view of counters in a grid format
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
            
            // MARK: PATTERN PDF DISPLAY
            // if the project was from the project explorer page, then display pdf
            if let pdfURL = rawPDFURL {
                PDFRemoteView(url: pdfURL)
                    .frame(height: 350)
                    .padding(.horizontal)
                
            } else {
                // if project was user created, show a text field for user notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pattern Notes")
                        .font(.headline)
                    
                    if showPatternEditor || project.patternText != nil {
                        // source: https://www.appcoda.com/learnswiftui/swiftui-texteditor.html
                        // source: https://dev.to/simrandotdev/swiftui-fix-cannot-convert-bindingstring-to-binding-in-textfield-5h5f#:~:text=Aug%2012%2C%202025-,SwiftUI%20Fix:%20Cannot%20Convert%20Binding%20to%20Binding,empty%20string%20if%20it's%20nil.
                        // source for done button to stop editing: https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
                        TextEditor(
                            text: Binding(
                                get: { project.patternText ?? "" },
                                set: { project.patternText = $0 }
                            )
                        )
                        .focused($isFocusedTextField)
                        .frame(minHeight: 200)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .toolbar { // add the done button for the keyboard which will dismiss the keyboard
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isFocusedTextField = false
                                }
                            }
                        }
                    // MARK: ADD PATTERN BUTTON
                    } else {
                        
                        Button {
                            showPatternEditor = true
                        } label: {
                            Label("Add Pattern", systemImage: "text.badge.plus")
                        }
                        .accessibilityLabel("Add Pattern Button")
                        .buttonStyle(.borderedProminent)
                        .tint(.title)
                        
                    }
                }
                .padding(.horizontal)
            }
        }
        // sheet popup to edit counters
        .sheet(isPresented: $showEditor) {
            CounterEditorView(project: project)
        }
        // sheet popup to pick a counter to increment when Audio counting is selected
        .sheet(isPresented: $showCounterPicker) {
            CounterPickerView(
                counters: project.counters,
                selectedCounter: $selectedCounter
            )
        }
        // if there is a selected counter for audio, then start the audio recording
        .onChange(of: selectedCounter) { oldValue, newValue in
            guard newValue != nil else { return }
            
            audioIsSelected = true
            recognizer.startRecording()
        }
        // if the count value has changed because of an audio command, update the new count value for the counter
        .onChange(of: recognizer.nextCount) { oldValue, newValue in
            guard recognizer.isRecording else { return }
            
            guard let counter = selectedCounter else {return}
            if newValue > counter.count {
                counter.count = newValue
            }
        }
        // request user permissions for audio recording
        .onAppear {
            recognizer.requestPermissions()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: COUNTER BUTTONS
// private extension since too complex for the compiler
private extension ProjectDescriptionView {
    var Buttons: some View {
        HStack {
            // Add counter button
            Button() {
                let newCounter = Counter(name: "Global")
                project.counters.append(newCounter)
            }
            label: {
                Label("Add", systemImage: "plus")
            }
            .accessibilityLabel("Add Counter")
            .buttonStyle(.borderedProminent)
            .tint(.title)
            // Edit counter button
            Button() {
                showEditor = true
            }
            label: {
                Label("Edit", systemImage: "pencil")
            }
            .accessibilityLabel("Edit Existing Counters")
            .buttonStyle(.borderedProminent)
            .tint(.title)
            // Audio recording button
            Button() {
                // if recording and button pressed, stop recording and de-select a counter for audio
                if recognizer.isRecording {
                    recognizer.stopRecording()
                    audioIsSelected = false
                    selectedCounter = nil
                } else {
                    // show the counter picker sheet if audio button is pressed
                    showCounterPicker = true
                }
            }
            // change the label and the color depending on if audio is recording or not
            label: {
                Label(audioIsSelected ? "Stop" : "Audio", systemImage: "microphone")
            }
            .accessibilityLabel(recognizer.isRecording ? "Stop Audio Recording" : "Start Audio Recording")
            .buttonStyle(.borderedProminent)
            .tint(audioIsSelected ? .accent : .title)
        }
    }
}
