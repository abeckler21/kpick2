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
    // initialize preferences at launch
    init() {
        UserDefaults.standard.register(defaults: [
            "developer_names": "Eve Tanios and Abby Beckler",
            "initial_launch": "Not yet set"
        ])
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "Initial Launch") == nil {
            let launchDate = Date()
            defaults.set(launchDate, forKey: "Initial Launch")

            // format launch date as readable string
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            defaults.set(formatter.string(from: launchDate), forKey: "initial_launch")
        }
        
        // increment number of launches for Rate this App alert
        let currentCount = defaults.integer(forKey: "launch_count")
        defaults.set(currentCount + 1, forKey: "launch_count")
    }

    // define app view
    var body: some Scene {
        WindowGroup {
            // make WithSplash view appear
            WithSplashView()
        }
        .modelContainer(for: Project.self)
    }
}
