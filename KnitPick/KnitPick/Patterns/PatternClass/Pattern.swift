//
//  Pattern.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation
import SwiftUI

// Pattern.swift: Pattern item, difficulty, category structures

enum PatternDifficulty: String, Codable, CaseIterable, Hashable {
    // PatternDifficulty: define difficulty levels
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct PatternCategory: Identifiable, Hashable {
    // PatternCategory: define categories w/id and name
    let id: String
    let name: String
}

struct PatternItem: Identifiable, Codable, Hashable {
    // PatternItem: define a pattern with given fields
    let id: String
    let title: String
    let pdfFileName: String
    let category: String
    let difficulty: PatternDifficulty
    let estimatedHours: Int
    let tags: [String]

    var displayTitle: String {
        // replace camel case title from PDF name w/ spaces
        title.replacingOccurrences(of: "_", with: " ")
    }

    var rawPDFURL: URL? {
        // get pdfURL w/filename and github repo base url
        URL(string: "https://raw.githubusercontent.com/etanios03/knitpick-patterns/main/\(pdfFileName)")
    }
}
