//
//  PatternsTabView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI

enum PatternRoute: Hashable {
    case category(PatternCategory)
    case pattern(PatternItem)
}

struct PatternsTabView: View {
    @State private var path: [PatternRoute] = []
    @State private var searchText = ""

    private let repository = PatternRepository.shared

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    private var allPatterns: [PatternItem] {
        repository.loadPatterns()
    }

    private var filteredCategories: [PatternCategory] {
        repository.categoriesMatching(searchText, from: allPatterns)
    }

    private var matchingPatterns: [PatternItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return repository.search(trimmed, in: allPatterns)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("All Patterns")
                        .font(.system(size: 36, weight: .bold))
                        .padding(.top, 8)

                    TextField("Search categories or patterns", text: $searchText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !matchingPatterns.isEmpty {
                        Text("Matching Patterns")
                            .font(.headline)
                            .padding(.top, 6)

                        VStack(spacing: 12) {
                            ForEach(matchingPatterns.prefix(5)) { pattern in
                                Button {
                                    path.append(.pattern(pattern))
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(pattern.displayTitle)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundStyle(.primary)

                                            Text("\(pattern.category) • \(pattern.difficulty.rawValue)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Text("Categories")
                        .font(.headline)
                        .padding(.top, 8)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredCategories) { category in
                            let previewPattern = repository.representativePattern(for: category, from: allPatterns)

                            Button {
                                path.append(.category(category))
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    PDFThumbnailView(
                                        url: previewPattern?.rawPDFURL,
                                        targetSize: CGSize(width: 320, height: 320),
                                        cropStyle: .category
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipped()

                                    LinearGradient(
                                        colors: [.clear, .black.opacity(0.18), .black.opacity(0.62)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )

                                    Text(category.name)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(14)
                                }
                                .frame(height: 150)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PatternRoute.self) { route in
                switch route {
                case .category(let category):
                    CategoryPatternsView(category: category)

                case .pattern(let pattern):
                    PatternDetailView(pattern: pattern)
                }
            }
        }
    }
}
