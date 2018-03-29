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
    func applyFilter(_ filter: CIFilter) -> CIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        filter.setValue(inputImage, forKey: "inputImage")
        
        guard let outputImage = filter.outputImage else { return nil }
        
        return outputImage.cropped(to: inputImage.extent)
    }
    // MARK: - Helper Methods
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.compactMap{ applyFilter($0) }
    }
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defualtFilters)
    }
}
