//
//  PDFThumbnailLoader.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI
import PDFKit
import Combine
import UIKit

enum ThumbnailCropStyle {
    case category
    case pattern
}

@MainActor
final class PDFThumbnailLoader: ObservableObject {
    @Published var image: UIImage?

    func loadThumbnail(
        from url: URL,
        targetSize: CGSize = CGSize(width: 600, height: 400),
        cropStyle: ThumbnailCropStyle = .pattern
    ) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let document = PDFDocument(data: data),
                  let firstPage = document.page(at: 0) else {
                return
            }

            let renderedSize = CGSize(width: 1400, height: 2000)
            let fullPageImage = firstPage.thumbnail(of: renderedSize, for: .mediaBox)

            let cropped = cropForCard(
                fullPageImage,
                targetAspectRatio: targetSize.width / targetSize.height,
                cropStyle: cropStyle
            )

            self.image = cropped
        } catch {
            print("Failed to load PDF thumbnail: \(error)")
        }
    }

    private func cropForCard(
        _ image: UIImage,
        targetAspectRatio: CGFloat,
        cropStyle: ThumbnailCropStyle
    ) -> UIImage {
        guard let cgImage = image.cgImage else { return image }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        let workingRect = contentFocusedRect(
            imageWidth: width,
            imageHeight: height,
            cropStyle: cropStyle
        )

        let workingAspect = workingRect.width / workingRect.height
        var cropRect: CGRect

        if workingAspect > targetAspectRatio {
            let cropWidth = workingRect.height * targetAspectRatio
            let x = workingRect.minX + (workingRect.width - cropWidth) / 2
            cropRect = CGRect(
                x: x,
                y: workingRect.minY,
                width: cropWidth,
                height: workingRect.height
            )
        } else {
            let cropHeight = workingRect.width / targetAspectRatio
            let y = workingRect.minY + (workingRect.height - cropHeight) / 2
            cropRect = CGRect(
                x: workingRect.minX,
                y: y,
                width: workingRect.width,
                height: cropHeight
            )
        }

        cropRect = cropRect.intersection(CGRect(x: 0, y: 0, width: width, height: height))

        guard let croppedCGImage = cgImage.cropping(to: cropRect.integral) else {
            return image
        }

        return UIImage(
            cgImage: croppedCGImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }

    private func contentFocusedRect(
        imageWidth: CGFloat,
        imageHeight: CGFloat,
        cropStyle: ThumbnailCropStyle
    ) -> CGRect {
        switch cropStyle {
        case .category:
            return CGRect(
                x: imageWidth * 0.06,
                y: imageHeight * 0.12,
                width: imageWidth * 0.88,
                height: imageHeight * 0.68
            )

        case .pattern:
            return CGRect(
                x: imageWidth * 0.04,
                y: imageHeight * 0.18,
                width: imageWidth * 0.92,
                height: imageHeight * 0.58
            )
        }
    }
}

struct PDFThumbnailView: View {
    let url: URL?
    let targetSize: CGSize
    let cropStyle: ThumbnailCropStyle

    @StateObject private var loader = PDFThumbnailLoader()

    init(
        url: URL?,
        targetSize: CGSize = CGSize(width: 600, height: 400),
        cropStyle: ThumbnailCropStyle = .pattern
    ) {
        self.url = url
        self.targetSize = targetSize
        self.cropStyle = cropStyle
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray5))
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .task(id: url?.absoluteString) {
            guard let url else { return }
            await loader.loadThumbnail(
                from: url,
                targetSize: targetSize,
                cropStyle: cropStyle
            )
        }
    }
}
