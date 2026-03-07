//
//  PatternDetailView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI
import PDFKit

struct PatternDetailView: View {
    let pattern: PatternItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(pattern.displayTitle)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 8)

                HStack {
                    Spacer()

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category: \(pattern.category)")
                        Text("Difficulty: \(pattern.difficulty.rawValue)")
                        Text("Estimated time: \(pattern.estimatedHours) hours")
                        Text("Tags: \(pattern.tags.joined(separator: ", "))")
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: 280)

                    Spacer()
                }

                if let url = pattern.rawPDFURL {
                    Link("Open PDF", destination: url)
                        .font(.headline)
                }

                PDFRemoteView(url: pattern.rawPDFURL)
                    .frame(minHeight: 600)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFRemoteView: View {
    let url: URL?

    var body: some View {
        Group {
            if let url {
                PDFKitRepresentedView(url: url)
            } else {
                Text("Invalid PDF URL")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .clear

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let document = PDFDocument(data: data) {
                    await MainActor.run {
                        pdfView.document = document
                    }
                }
            } catch {
                print("Failed to load remote PDF: \(error)")
            }
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
