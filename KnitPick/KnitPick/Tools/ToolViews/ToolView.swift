//
//  ToolView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/26/26.
//

import Foundation
import SwiftUI

//  ToolView.swift: view for Tools page

enum ToolType: Hashable {
    case commonStitches
    case voiceRowCounter
    case tool(String)
}


struct ToolView: View {
    // ToolView: define the list of tools to be displayed in tool view
    @State private var path: [ToolType] = []
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        // define scroll view with two columns of tools
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ToolCard(title: "Common\nStitches") {
                            path.append(.commonStitches)
                        }
                        
                        ToolCard(title: "Voice\nRow Counter") {
                            path.append(.voiceRowCounter)
                        }

                        ToolCard(title: "Pattern Size\nAdjuster") {
                            path.append(.tool("Pattern Size Adjuster"))
                        }

                        ToolCard(title: "Yarn Yardage\nCalculator") {
                            path.append(.tool("Yarn Yardage Calculator"))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Tools")
            // set destination as stitch view or placeholder view
            .navigationDestination(for: ToolType.self) { route in
                switch route {
                case .commonStitches:
                    CommonStitchesView()
                    
                case .voiceRowCounter:
                       VoiceRowCounterView()
                    
                case .tool(let name):
                    PlaceholderToolView(title: name)
                }
            }
        }
    }
}


struct ToolCard: View {
    // ToolCard: view for text on top of gray blob
    let title: String
    let onTap: () -> Void

    var body: some View {
        // define button with text stacked on rect
        Button(action: onTap) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray5))
                    .frame(height: 150)

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.custom("Pixelstitch", size: 16))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(14)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title.replacingOccurrences(of: "\n", with: " "))
        .accessibilityHint("Opens tool")
    }
}


struct PlaceholderToolView: View {
    // PlaceholderToolView: view for placeholder tools
    let title: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title).font(.title.bold())
            Text("Coming soon.")
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
