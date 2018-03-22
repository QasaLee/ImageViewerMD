//
//  PhotoFilters.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/22/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import CoreImage

struct PhotoFilter {
    private static var colorClamp: CIFilter {
        let colorClamp = CIFilter(name: "CIColorClamp")!
        let minVector = CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2)
        let maxVector = CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9)
        colorClamp.setValue(minVector, forKey: "inputMinComponents")
        colorClamp.setValue(maxVector, forKey: "inputMaxComponents")
        return colorClamp
    }
    private static var colorControls: CIFilter {
        let colorControls = CIFilter(name: "CIColorControls")!
        colorControls.setValue(0.1, forKey: "inputSaturation")
        return colorControls
    }
    private static var sepia: CIFilter {
        let sepia = CIFilter(name: "CISepiaTone")!
        sepia.setValue(0.7, forKey: "inputIntensity")
        return sepia
    }
    static var defualtFilters: [CIFilter] {
        let instantPhoto = CIFilter(name: "CIPhotoEffectInstant")!
        let processPhoto = CIFilter(name: "CIPhotoEffectProcess")!
        let noirPhoto = CIFilter(name: "CIPhotoEffectNoir")!
        
        return [colorClamp, colorControls, sepia, instantPhoto, processPhoto, noirPhoto]
    }
}
