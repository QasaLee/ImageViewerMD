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
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = photo.image
    }
}
