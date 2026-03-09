//
//  ProjectRow.swift
//  KnitPick
//
//  Created by Eve Tanios on 2/28/26.
//

import SwiftUI
// configuration of a specific project, separated just to make code a little more readable
struct ProjectRowView: View {
    let project: Project
    
    var body: some View {
        // Project has a name and image in a row 
        HStack {
            Image(systemName: "doc.text")
            Text(project.name)
        }
    }
}
