//
//  CommonStitchesView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/28/26.
//

import Foundation
import SwiftUI

// CommonStitchesView.swift: view for common stitches page

struct CommonStitchesView: View {
    // CommonStitchesView: define view with list of stitches and search
    @State private var query = ""
    private let stitches = Stitch.sample
    private var filtered: [Stitch] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return stitches }
        return stitches.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }

    var body: some View {
        // list all stitches that haven't been filtered out via search
        List(filtered) { stitch in
            NavigationLink {
                StitchDetailView(stitch: stitch)
            } label: {
                Text(stitch.name)
            }
        }
        .navigationTitle("Common Stitches")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $query, prompt: "Search stitches")
    }
}
