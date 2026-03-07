//
//  PatternDetailView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import Foundation
import SwiftUI
import PDFKit
import SwiftData

// PatternDetailView.swift: define view of a specific pattern

struct PatternDetailView: View {
    // PatternDetailView: view showing detailed information about a selected knitting pattern
    @Environment(\.modelContext) private var context
    @Query private var projects: [Project]
    @State private var justAdded = false
    let pattern: PatternItem

    private var alreadyAdded: Bool {
        projects.contains { $0.name == pattern.displayTitle }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(pattern.displayTitle)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 8)

                // define pattern metadata block
                HStack {
                    Spacer()

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category: \(pattern.category)")
                        Text("Difficulty: \(pattern.difficulty.rawValue)")
                        Text("Estimated time: \(pattern.estimatedHours) hours")
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
                    // if PDF exists, add link to it
                    Link("Open PDF", destination: url)
                        .font(.headline)
                }

                // display the PDF of the pattern
                PDFRemoteView(url: pattern.rawPDFURL)
                    .frame(minHeight: 600)

                // 'Add to my projects' button
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
        // buttonTitle: change title of button to 'Added!' when added to My projects
        if (alreadyAdded || justAdded) {
            return "Added!"
        } else {
            return "Add to My Projects"
        }
    }

    private func addToProjects() {
        // addToProjects: create new project item from pattern and add to context
        guard !alreadyAdded else { return }

        let newProject = Project(
            name: pattern.displayTitle,
            counters: [Counter(name: "Global", count: 0)]
        )
        newProject.pdfFileName = pattern.pdfFileName
        context.insert(newProject)
        justAdded = true
    }
}

struct PDFRemoteView: View {
    // PDFRemoteView: if URL exists, create a View using the following wrapper
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
    // PDFKitRepresentedView: wrapper to bridge swiftui and pdfkit
    let url: URL
    func makeUIView(context: Context) -> PDFView {
        // create the pdf viewer
        let pdfView = PDFView()
        
        // configure pdf display settings
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.usePageViewController(true)
        pdfView.displayDirection = .horizontal
        pdfView.backgroundColor = .clear
        
        // download and load the pdf asynchronously
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
    
    // required update function for uiviewrepresentable
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
