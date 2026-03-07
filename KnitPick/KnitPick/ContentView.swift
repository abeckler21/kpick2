//
//  ContentView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/26/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MyProjectsView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Projects")
                }
            
            ToolView()
                .tabItem { Label("Tools", systemImage: "wrench.and.screwdriver") }
            
            CategoriesView()
                    .tabItem { Label("All Patterns", systemImage: "square.grid.2x2") }
        }
    }
}

#Preview {
    ContentView()
}
