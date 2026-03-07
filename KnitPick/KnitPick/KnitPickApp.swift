//
//  KnitPickApp.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/26/26.
//

import SwiftUI
import SwiftData
@main
struct KnitPickApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.font, Font.custom("Pixelstitch", size: 16))
        }
        .modelContainer(for: Project.self)
    }
}
