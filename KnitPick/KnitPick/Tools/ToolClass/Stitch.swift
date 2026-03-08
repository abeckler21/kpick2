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
    // Stitch: define a stitch struct w/id, name, and instructions
    let id = UUID()
    let name: String
    let howTo: String
    let image: String
}


// define dictionary of stitches for Common Stitches page
extension Stitch {
    static let sample: [Stitch] = [
        Stitch(
            name: "Garter Stitch",
            howTo: "Cast on the number of stitches you need, then knit every stitch in every row. Turn your work at the end of each row and repeat.",
            image: "garter"
        ),
        Stitch(
            name: "Stockinette Stitch",
            howTo: "Odd rows: knit all stitches. Even rows: purl all stitches. Repeat these 2 rows until you reach the desired length.",
            image: "stockinette"
        
        ),
        Stitch(
            name: "Lined Stockinette Stitch",
            howTo: "Row 1: knit all. Row 2: purl all. Row 3: knit all. Row 4: knit all. Repeat these 4 rows until you reach the desired length.",
            image: "lined"
        ),
        Stitch(
            name: "Rib Stitch (1x1)",
            howTo: "If you have an even number of stitches: all rows, repeat K1, P1 to the end. If you have an odd number of stitches: odd rows, repeat K1, P1; even rows, repeat P1, K1.",
            image: "rib"
        ),
        Stitch(
            name: "Seed Stitch",
            howTo: "If you have an odd number of stitches: all rows, repeat K1, P1 to the end. If you have an even number of stitches: odd rows, repeat K1, P1; even rows, repeat P1, K1. Repeat until desired length.",
            image: "seed"
        ),
        Stitch(
            name: "Moss Stitch",
            howTo: "Cast on an even number of stitches. Rows 1 and 2: repeat K1, P1 to the end. Rows 3 and 4: repeat P1, K1 to the end. Repeat these 4 rows.",
            image: "moss"
        ),
        Stitch(
            name: "Waffle Stitch",
            howTo: "Cast on a multiple of 3 stitches, then add 1 more stitch. Row 1: repeat K1, P2 until 1 stitch remains, then K1. Row 2: P1, then repeat K2, P1 to the end. Row 3: knit all. Row 4: purl all. Repeat these 4 rows.",
            image: "waffle"
        )
    ]
}
