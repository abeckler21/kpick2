//
//  PatternRepository.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation
import SwiftUI

// PatternRepository.swift: loading & filtering patterns from JSON file

class PatternRepository {
    // PatternRepository: define repository responsible for loading and organizing knitting patterns
    static let shared = PatternRepository()
    
    func loadPatterns() -> [PatternItem] {
        // loadPatterns: loads all pattern items from the bundled json manifest file
        guard let url = Bundle.main.url(forResource: "PatternManifest", withExtension: "json") else {
            print("Could not find PatternManifest.json in app bundle.")
            return []
        }

        do {
            // read and decode JSON contents
            let data = try Data(contentsOf: url)
            let patterns = try JSONDecoder().decode([PatternItem].self, from: data)
            return patterns.sorted { $0.displayTitle < $1.displayTitle }
        } catch {
            print("Failed to decode PatternManifest.json: \(error)")
            return []
        }
    }

    func categories(from patterns: [PatternItem]) -> [PatternCategory] {
        // categories: builds a list of unique categories from the pattern collection
        let names = Array(Set(patterns.map { $0.category }))
            .sorted()
        return names.map { PatternCategory(id: $0, name: $0) }
    }

    func patterns(in category: PatternCategory, from patterns: [PatternItem]) -> [PatternItem] {
        // patterns: returns all patterns that belong to a specific category
        patterns.filter { $0.category == category.name }
    }

    func search(_ query: String, in patterns: [PatternItem]) -> [PatternItem] {
        // search: searches patterns by title, category, or tags
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return patterns }

        return patterns.filter { pattern in
            pattern.displayTitle.localizedCaseInsensitiveContains(trimmed) ||
            pattern.category.localizedCaseInsensitiveContains(trimmed) ||
            pattern.tags.contains(where: { $0.localizedCaseInsensitiveContains(trimmed) })
        }
    }

    func firstPattern(for category: PatternCategory, from patterns: [PatternItem]) -> PatternItem? {
        // firstPattern: returns the first pattern in category for displaying a category thumbnail
        self.patterns(in: category, from: patterns).first
    }
}
