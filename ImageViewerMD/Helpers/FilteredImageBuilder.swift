//
//  FilteredImageBuilder.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/22/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import CoreImage
import UIKit

class FilteredImageBuilder {
    private let image: UIImage
    private let context: CIContext
    init(image: UIImage, context: CIContext) {
        self.image = image
        self.context = context
    }
    func applyFilter(_ filter: CIFilter) -> CGImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        filter.setValue(inputImage, forKey: "inputImage")
        guard let outputImage = filter.outputImage else { return nil }
        return context.createCGImage(outputImage, from: inputImage.extent)
    }
    // MARK: - Helper Methods
    func image(withFilters filters: [CIFilter]) -> [CGImage] {
        return filters.compactMap { applyFilter($0) }
    }
    func imageWithDefaultFilters() -> [CGImage] {
        return image(withFilters: PhotoFilter.defualtFilters)
    }
}
