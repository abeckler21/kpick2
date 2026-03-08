//
//  StitchDetailView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/28/26.
//

import Foundation
import SwiftUI

// StitchDetailView.swift: view for a description of a stitch type

struct StitchDetailView: View {
    // StitchDetailView: view details of a specific stitch
    let stitch: Stitch

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(stitch.name)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)

                Divider()

                Text("How-To:")
                    .font(.system(size: 18, weight: .semibold))

                Text(stitch.howTo)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(stitch.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 8)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
