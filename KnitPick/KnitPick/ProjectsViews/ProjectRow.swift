//
//  ProjectRow.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/28/26.
//

import SwiftUI
struct ProjectRow: View {
    let project: Project
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text")
            Text(project.name)
        }
    }
}
