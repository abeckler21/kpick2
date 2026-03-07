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
            // make WithSplash view appear
            WithSplashView()
        }
        .modelContainer(for: Project.self)
    }
}
