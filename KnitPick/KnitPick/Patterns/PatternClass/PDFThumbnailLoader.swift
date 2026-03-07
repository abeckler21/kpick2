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

// defines different cropping behaviors depending on where the thumbnail is used
enum ThumbnailCropStyle {
    case category
    case pattern
}


@MainActor
final class PDFThumbnailLoader: ObservableObject {
    // PDFThumbnailLoader: generate cropped thumbnails from remote pdf files
    @Published var image: UIImage?

    // downloads a pdf and generates a cropped thumbnail image
    func loadThumbnail(
        from url: URL,
        targetSize: CGSize = CGSize(width: 600, height: 400),
        cropStyle: ThumbnailCropStyle = .pattern
    ) async {
        do {
            // download the pdf data from the remote url
            let (data, _) = try await URLSession.shared.data(from: url)

            // create a pdf document and grab the first page
            guard let document = PDFDocument(data: data),
                  let firstPage = document.page(at: 0) else {
                return
            }

            // render the first page into a large image
            let renderedSize = CGSize(width: 1400, height: 2000)
            let fullPageImage = firstPage.thumbnail(of: renderedSize, for: .mediaBox)

            // crop the rendered image to fit the card layout
            let cropped = cropForCard(
                fullPageImage,
                targetAspectRatio: targetSize.width / targetSize.height,
                cropStyle: cropStyle
            )

            // publish the final image to update the view
            self.image = cropped

        } catch {
            // print error if the pdf fails to load
            print("Failed to load PDF thumbnail: \(error)")
        }
    }

    // crops the rendered pdf page to match the card aspect ratio
    private func cropForCard(
        _ image: UIImage,
        targetAspectRatio: CGFloat,
        cropStyle: ThumbnailCropStyle
    ) -> UIImage {
        // get the underlying cgimage for cropping
        guard let cgImage = image.cgImage else { return image }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        // determine the content area we want to crop from
        let workingRect = contentFocusedRect(
            imageWidth: width,
            imageHeight: height,
            cropStyle: cropStyle
        )

        let workingAspect = workingRect.width / workingRect.height
        var cropRect: CGRect

        // crop horizontally if the working area is too wide
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

            // crop vertically if the working area is too tall
            let cropHeight = workingRect.width / targetAspectRatio
            let y = workingRect.minY + (workingRect.height - cropHeight) / 2

            cropRect = CGRect(
                x: workingRect.minX,
                y: y,
                width: workingRect.width,
                height: cropHeight
            )
        }

        // ensure crop stays inside the image bounds
        cropRect = cropRect.intersection(CGRect(x: 0, y: 0, width: width, height: height))

        // perform the crop
        guard let croppedCGImage = cgImage.cropping(to: cropRect.integral) else {
            return image
        }

        // convert back to uiimage
        return UIImage(
            cgImage: croppedCGImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }

    // defines which part of the pdf page contains the important visual content
    private func contentFocusedRect(
        imageWidth: CGFloat,
        imageHeight: CGFloat,
        cropStyle: ThumbnailCropStyle
    ) -> CGRect {

        switch cropStyle {

        // category tiles: keep most of the center content
        case .category:
            return CGRect(
                x: imageWidth * 0.06,
                y: imageHeight * 0.12,
                width: imageWidth * 0.88,
                height: imageHeight * 0.68
            )

        // pattern cards: bias the crop toward the middle where the product photo usually is
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
    // PDFThumbnailView: view that displays a generated pdf thumbnail
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
            // display the thumbnail if it exists
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                // placeholder shown while thumbnail loads
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray5))
                    .overlay {
                        ProgressView()
                    }
            }
        }
        // load the thumbnail when the view appears
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
