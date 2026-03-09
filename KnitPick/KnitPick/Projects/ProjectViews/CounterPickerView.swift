//
//  CounterPickerView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/8/26.
//
import SwiftUI
import SwiftData

// When the Audio button is pressed, this view pops up so that the user can select which counter to increment by voice command
// contains a list of counters as buttons for an associated project
struct CounterPickerView: View {

    var counters: [Counter]
    // selected counter for projectDescriptionView for Audio functionality
    @Binding var selectedCounter: Counter?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            // list of counters, each counter description is a button
            List(counters) { counter in
                Button {
                    // when button clicked, make that counter the selected counter
                    // then dismiss page
                    selectedCounter = counter
                    dismiss()
                } label: {
                    Text(counter.name)
                }
            }
            .navigationTitle("Select Counter")
        }
    }
}
