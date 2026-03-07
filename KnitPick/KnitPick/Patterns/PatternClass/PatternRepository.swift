//
//  PatternRepository.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation

final class PatternRepository {
    static let shared = PatternRepository()

    private init() {}

    func loadPatterns() -> [PatternItem] {
        guard let url = Bundle.main.url(forResource: "PatternManifest", withExtension: "json") else {
            print("Could not find PatternManifest.json in app bundle.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let patterns = try JSONDecoder().decode([PatternItem].self, from: data)
            return patterns.sorted { $0.displayTitle < $1.displayTitle }
        } catch {
            print("Failed to decode PatternManifest.json: \(error)")
            return []
        }
    }

    func categories(from patterns: [PatternItem]) -> [PatternCategory] {
        let names = Array(Set(patterns.map { $0.category })).sorted()
        return names.map { PatternCategory(id: $0, name: $0) }
    }

    func patterns(in category: PatternCategory, from patterns: [PatternItem]) -> [PatternItem] {
        patterns.filter { $0.category == category.name }
    }

    func search(_ query: String, in patterns: [PatternItem]) -> [PatternItem] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return patterns }

        return patterns.filter { pattern in
            pattern.displayTitle.localizedCaseInsensitiveContains(trimmed) ||
            pattern.category.localizedCaseInsensitiveContains(trimmed) ||
            pattern.tags.contains(where: { $0.localizedCaseInsensitiveContains(trimmed) })
        }
    }

    func categoriesMatching(_ query: String, from patterns: [PatternItem]) -> [PatternCategory] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let allCategories = categories(from: patterns)

        guard !trimmed.isEmpty else { return allCategories }

        let directCategoryMatches = allCategories.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed)
        }

        let patternMatches = search(trimmed, in: patterns)
        let matchedCategoryNames = Set(patternMatches.map { $0.category })

        let indirectMatches = allCategories.filter {
            matchedCategoryNames.contains($0.name)
        }

        var seen = Set<String>()
        return (directCategoryMatches + indirectMatches).filter { seen.insert($0.id).inserted }
    }

    func representativePattern(for category: PatternCategory, from patterns: [PatternItem]) -> PatternItem? {
        self.patterns(in: category, from: patterns).first
    }
}
