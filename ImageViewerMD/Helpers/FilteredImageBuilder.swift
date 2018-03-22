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
    init(image: UIImage) {
        self.image = image
    }
    func applyFilter(_ filter: CIFilter) -> UIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        filter.setValue(inputImage, forKey: "inputImage")
        guard let outputImage = filter.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }
    func image(withFilters filters: [CIFilter]) -> [UIImage] {
        return filters.compactMap{ applyFilter($0) }
    }
    func imageWithDefaultFilters() -> [UIImage] {
        return image(withFilters: PhotoFilter.defualtFilters)
    }
}
