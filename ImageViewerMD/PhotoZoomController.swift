//
//  PhotoZoomController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/17/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoZoomController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var imageViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraints: NSLayoutConstraint!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = photo.image
        photoImageView.sizeToFit() // Seems nothing changes
        scrollView.contentSize = photoImageView.bounds.size // 如果没这句也能zoom
        
        view.backgroundColor = .black
        updateZoomScale()
        updateConstraintsForSize(view.bounds.size) // bounds, frame的size都是一样的
    }
    
    var minScale: CGFloat {
        let viewSize = view.bounds.size
        let widthScale = viewSize.width / photoImageView.bounds.width
        let heightScale = viewSize.height / photoImageView.bounds.height
        return min(widthScale, heightScale)
    }
    
    func updateZoomScale() {
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale * 1.0 // 决定最初的ZoomScale
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
        let verticalSpace = size.height - photoImageView.frame.height // When zooming in, photoImageView's size is getting bigger.
        let yOffset = max(0, verticalSpace / 2)
        let xOffset = max(0, (size.width - photoImageView.frame.width) / 2)
        
        imageViewTopConstraints.constant = yOffset
        imageViewBottomConstraints.constant = yOffset
        imageViewLeadingConstraints.constant = xOffset
        imageViewTrailingConstraints.constant = xOffset
    }
}

extension PhotoZoomController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView // Tell the controller photoImageView can actually ZOOM!
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < minScale * 0.7 {
            dismiss(animated: true, completion: nil)
        }
        updateConstraintsForSize(view.bounds.size) // Fixed a  mysterious bug, and FYI: "bounds" and "frame" is of the same function in this case.
    }
}
