//
//  PhotoFilterController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/21/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    var photoImage: UIImage?
    var context: CIContext!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    // Todo: Crop imageView to square!
    
    private lazy var filteredImages: [CGImage] = {
        guard let image = self.photoImage else { return [] }
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
        let cgImage = filteredImages[indexPath.row]
        cell.imageView.image = UIImage(cgImage: cgImage) // Expensive!!!

        return cell
    }
}
