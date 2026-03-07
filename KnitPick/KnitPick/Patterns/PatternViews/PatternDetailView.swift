//
//  PatternDetailView.swift
//  KnitPick
//

import SwiftUI
import PDFKit
import SwiftData

struct PatternDetailView: View {
    let pattern: PatternItem

    @Environment(\.modelContext) private var context
    @Query private var projects: [Project]
    @State private var justAdded = false

    private var alreadyAdded: Bool {
        projects.contains { $0.name == pattern.displayTitle }
    }

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

                Button {
                    addToProjects()
                } label: {
                    Text(buttonTitle)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .disabled(alreadyAdded)
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var buttonTitle: String {
        if (alreadyAdded || justAdded) {
            return "Added!"
        } else {
            return "Add to My Projects"
        }
    }

    private func addToProjects() {
        guard !alreadyAdded else { return }

        let newProject = Project(
            name: pattern.displayTitle,
            counters: [Counter(name: "Global", count: 0)]
        )
        context.insert(newProject)
        justAdded = true
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
