//
//  PhotoFilterController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/21/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    var photoImage: UIImage?
    // Todo: Crop imageView to square!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photoImage
    }
}
