//
//  LineEditorView.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//
import SwiftUI

struct LineEditorView: View {
    @Binding var cells: [TableCell]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
         NavigationStack {
             List {
                 ForEach($cells) { $cell in
                     TextField("Cell text", text: $cell.text)
                 }
                 .onDelete { indexSet in
                     cells.remove(atOffsets: indexSet)
                 }
                 Button("Add Cell") {
                     cells.append(TableCell(text: "New"))
                 }
             }
             .navigationTitle("Edit Cells")
             .toolbar {
                 ToolbarItem(placement: .confirmationAction) {
                     Button("Done") {
                         dismiss()
                     }
                 }
             }
         }
     }
}
