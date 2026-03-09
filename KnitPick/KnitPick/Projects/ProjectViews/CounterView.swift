//
//  CounterView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftUI
import SwiftData

// View to show counters display on ProjectDescriptionView
// Adaptable grid that displays a variable num of counters per row depending on phone size
struct CounterView: View {
    @Bindable var counter: Counter
    
    var body: some View {
        VStack {
            Text("\(counter.name)")
            // increment and decrement buttons horizontal of counter name
            HStack {
                Button("-") {
                    if counter.count > 0 {
                        counter.count-=1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.title)
                .accessibilityLabel("Subtract from Row Count")
                Text("\(counter.count)")
                Button("+") {
                    counter.count+=1
                }
                .buttonStyle(.borderedProminent)
                .tint(.title)
                .accessibilityLabel("Add to Row Count")
            }
        }
        .background(.gray.opacity(0.15))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}
