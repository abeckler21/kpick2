//
//  PDFViewer.swift
//  KnitPick
//
//  Created by Eve Tanios on 3/7/26.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    
    let fileName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        }
    }
}
