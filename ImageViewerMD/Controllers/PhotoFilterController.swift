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

    let eaglContext = EAGLContext(api: .openGLES3)
    
    var photoImage: UIImage?
    // Todo: Crop imageView to square!
    var context: CIContext!

    private lazy var filteredImages: [CIImage] = {
        guard let image = self.photoImage else { return [] }
        guard let context = context else { return [] }
        let filteredImageBuilder = FilteredImageBuilder(image: image, context: context)
        return  filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photoImage
        filtersCollectionView.dataSource = self
    }
}

extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        let image = filteredImages[indexPath.row]
        cell.eaglContext = eaglContext
        cell.image = image
        return cell
    }
}
