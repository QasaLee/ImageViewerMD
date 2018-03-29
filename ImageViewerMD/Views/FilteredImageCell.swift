//
//  FilteredImageCell.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/23/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit
import GLKit

class FilteredImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FilteredImageCell.self)
    
    var eaglContext: EAGLContext!
    var image: CIImage!
    
    private lazy var glkView: GLKView = {
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.translatesAutoresizingMaskIntoConstraints = false // If I want to use AutoLayout instead of frame-based layout and this specific UIView will be added to a view hierarchy which is using AutoLayout.
        // In Conlusion: set this property to false will allow autolayout to change the layout of this view.
        view.delegate = self // GLKView uses delegate to draw!!!
        return view
    }()
    
    
    private lazy var context: CIContext = { // In the end needs a CIContext to draw.
        return CIContext(eaglContext: eaglContext)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews() // cell sets itself up
        
        contentView.addSubview(glkView)
        NSLayoutConstraint.activate([
            glkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            glkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

extension FilteredImageCell: GLKViewDelegate { // The entire cell is the area where a  GLKView will draw.
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
//        context.draw(image, in: rect, from: image.extent)
        let drawableRectSize = CGSize(width: view.drawableWidth, height: view.drawableHeight)
        let drawableRect = CGRect(origin: .zero, size: drawableRectSize)
        context.draw(image, in: drawableRect, from: image.extent)
    }
}
