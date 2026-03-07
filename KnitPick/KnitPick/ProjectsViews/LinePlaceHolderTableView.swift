//
//  LinePlaceHolderTable.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftUI

struct TableCell: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct LinePlaceHolderTableView: View {
    @State private var cells: [TableCell] = [
        TableCell(text: "K"),
        TableCell(text: "P"),
        TableCell(text: "YO"),
        TableCell(text: "K2")
    ]

    @State private var selected: UUID?
    @State private var showEditSheet = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(cells) { cell in
                        Text(cell.text)
                            .frame(width: 60, height: 60)
                            .background(
                                selected == cell.id ?
                                    .title : .subtitle)
                            .cornerRadius(10)
                            .onTapGesture {
                                // if the cell tapped is the currently selected cell, then unselect
                                if cell.id == selected {
                                    selected = nil
                                }
                                else {
                                    selected = cell.id
                                }
                                
                            }
                    }
                }
                .padding()
            }

            Button("Edit") {
                showEditSheet = true
            }
        }
        .sheet(isPresented: $showEditSheet) {
            LineEditorView(cells: $cells)
        }
    }
}
