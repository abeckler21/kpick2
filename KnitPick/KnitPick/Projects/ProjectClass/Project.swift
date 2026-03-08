//
//  Project.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftData

@Model
class Project {
    var name: String
    var counters: [Counter]
    var pdfFileName: String?
    // text if no pdf present
    var patternText: String?
    init(name: String, counters: [Counter]) {
        self.name = name
        self.counters = [Counter(name:"Global", count: 0)]
        self.pdfFileName = nil
        self.patternText = ""
    }
}
