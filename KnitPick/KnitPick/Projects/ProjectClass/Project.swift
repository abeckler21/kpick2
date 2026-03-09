//
//  Project.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/5/26.
//

import SwiftData

// https://www.hackingwithswift.com/quick-start/swiftdata/why-are-swiftdata-models-created-as-classes
// the Project model contains a project name, a list of Counters, and pattern text information
// if the Project was from a pre-existing Pattern (in the pattern explorer tab), then a pdfFile is associated with it
// if the Project was created by the user, then a patternText box can be edited by the user to contain project notes
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
