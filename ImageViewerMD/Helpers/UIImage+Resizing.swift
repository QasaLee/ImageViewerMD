//
//  UIImage+Resizing.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/29/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? { // -ed indicates this is going to be a copy while -ing indicating mutate the original image.
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContext(size) // It was "rect.size" but I thought it would be cumbersome.
        self.draw(in: rect)
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
