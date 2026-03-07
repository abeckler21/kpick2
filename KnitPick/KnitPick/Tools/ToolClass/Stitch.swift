//
//  Stitch.swift
//  KnitPick
//
//  Created by Abigail Beckler on 2/28/26.
//

import Foundation
import SwiftUI

// Stitch.swift: Stitch type, extension with data

struct Stitch: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let howTo: String
}


extension Stitch {
    static let sample: [Stitch] = [
        Stitch(
            name: "Irish Moss Stitch",
            howTo: "Knit every row flat."
        ),
        Stitch(
            name: "Garter Stitch",
            howTo: "Knit every row (or purl every row) flat."
        ),
        Stitch(
            name: "Stockinette Stitch",
            howTo: "Row 1: Knit. Row 2: Purl. Repeat."
        ),
        Stitch(
            name: "Rib Stitch (1x1)",
            howTo: "Repeat K1, P1 across each row."
        )
    ]
}
