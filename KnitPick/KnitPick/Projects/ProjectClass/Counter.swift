//
//  Counter.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftUI
import SwiftData

// https://www.hackingwithswift.com/quick-start/swiftdata/why-are-swiftdata-models-created-as-classes
// Counter model contains a name and a count, and is stored persistently in the app data
@Model
class Counter {
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0) {
        self.name = name
        self.count = count
    }
}
