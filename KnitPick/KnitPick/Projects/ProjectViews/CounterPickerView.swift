//
//  CounterPickerView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/8/26.
//
import SwiftUI
import SwiftData
struct CounterPickerView: View {

    var counters: [Counter]
    @Binding var selectedCounter: Counter?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(counters) { counter in
                Button {
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
