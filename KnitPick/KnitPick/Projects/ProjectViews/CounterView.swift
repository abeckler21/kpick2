//
//  CounterView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    @Bindable var counter: Counter
    
    var body: some View {
        VStack {
            Text("\(counter.name)")
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
