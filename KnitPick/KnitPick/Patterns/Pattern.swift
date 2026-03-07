//
//  Pattern.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation

enum PatternDifficulty: String, Codable, CaseIterable, Hashable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct PatternCategory: Identifiable, Hashable {
    let id: String
    let name: String
}

struct PatternItem: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let pdfFileName: String
    let category: String
    let difficulty: PatternDifficulty
    let estimatedHours: Int
    let tags: [String]

    var displayTitle: String {
        title.replacingOccurrences(of: "_", with: " ")
    }

    var rawPDFURL: URL? {
        URL(string: "https://raw.githubusercontent.com/etanios03/knitpick-patterns/main/\(pdfFileName)")
    }
}
