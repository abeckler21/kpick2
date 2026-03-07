//
//  Counter.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftUI
import SwiftData

@Model
class Counter {
    var name: String
    var count: Int
    
    init(name: String, count: Int = 0) {
        self.name = name
        self.count = count
    }
}
