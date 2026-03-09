//
//  CategoriesView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation
import SwiftUI

// CategoriesView.swift: define the Category tab view w/search capabilities

enum PatternRoute: Hashable {
    // PatternRoute: navigation routes used within the patterns tab
    case category(PatternCategory)
    case pattern(PatternItem)
}

struct CategoriesView: View {
    // CategoriesView: main view for the patterns tab
    @StateObject private var networkMonitor = NetworkMonitor()
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

    private var allCategories: [PatternCategory] {
        repository.categories(from: allPatterns)
    }

    private var matchingPatterns: [PatternItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return repository.search(trimmed, in: allPatterns)
    }

    var body: some View {
        NavigationStack(path: $path) {
            if networkMonitor.isConnected {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Search categories or patterns", text: $searchText)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        // show search results only when the user enters text
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
                        
                        // section header for category grid
                        Text("Categories")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        // grid of pattern categories
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(allCategories) { category in
                                // choose the first pattern in the category to use to generate the category thumbnail
                                let previewPattern = repository.firstPattern(for: category, from: allPatterns)
                                
                                // button navigates to the selected category
                                Button {
                                    path.append(.category(category))
                                } label: {
                                    ZStack(alignment: .bottomLeading) {
                                        // category preview image generated from a pattern pdf
                                        PDFThumbnailView(
                                            url: previewPattern?.rawPDFURL,
                                            targetSize: CGSize(width: 320, height: 320),
                                            cropStyle: .category
                                        )
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .clipped()
                                        .accessibilityHidden(true)
                                        
                                        // gradient to make text more legible
                                        LinearGradient(
                                            colors: [.clear, .black.opacity(0.18), .black.opacity(0.62)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        .accessibilityHidden(true)
                                        
                                        Text(category.name)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .padding(14)
                                    }
                                    // styluing for the category cards
                                    .frame(height: 150)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .contentShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .buttonStyle(.plain)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(category.name)
                                .accessibilityHint("Opens category")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                .navigationTitle("All Patterns")
                // define navigation destinations for routes
                .navigationDestination(for: PatternRoute.self) { route in
                    switch route {
                    case .category(let category):
                        CategoryPatternsView(category: category)
                    case .pattern(let pattern):
                        PatternDetailView(pattern: pattern)
                    }
                }
            } else {
                // message for when not on the internet
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    
                    Text("Connect to the internet to see patterns")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
        }
    }
}
