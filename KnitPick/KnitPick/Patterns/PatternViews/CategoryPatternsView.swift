//
//  CategoryPatternsView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation
import SwiftUI

// CategoryPatternsView.swift: define view of a specific category full of patterns

struct CategoryPatternsView: View {
    // CategoryPatternsView: view showing all patterns inside a selected category
    let category: PatternCategory
    private let repository = PatternRepository.shared
    private var patterns: [PatternItem] {
        repository.patterns(in: category, from: repository.loadPatterns())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // display category name
                Text(category.name)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 8)

                // display each pattern
                ForEach(patterns) { pattern in
                    NavigationLink(value: PatternRoute.pattern(pattern)) {
                        ZStack(alignment: .bottomLeading) {
                            PDFThumbnailView(
                                url: pattern.rawPDFURL,
                                targetSize: CGSize(width: 700, height: 300),
                                cropStyle: .pattern
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()

                            // add gradient to make text more legible
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.18), .black.opacity(0.62)],
                                startPoint: .top,
                                endPoint: .bottom
                            )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(pattern.displayTitle)
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .lineLimit(2)

                                Text("\(pattern.difficulty.rawValue) • \(pattern.estimatedHours) hrs")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.92))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                        }
                        .frame(height: 165)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        // set navigation bar title to the category name
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
