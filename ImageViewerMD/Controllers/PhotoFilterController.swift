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
    let filters = PhotoFilter.defualtFilters
    
    let filtrationQueue = OperationQueue()
    var filtrationsInProgress = Set<IndexPath>()
    
    lazy var filtrationImages: [FiltrationImage] = {
        guard let image = self.photoImage else { return [] }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let scaledWidth: CGFloat = 100
        let scaledRatio = scaledWidth / imageWidth
        let scaledHeight = imageHeight * scaledRatio
        let rect = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return [] }
        UIGraphicsEndImageContext()
        
        return self.filters.map { _ in // 这里filters只是个计数器的功能
            return FiltrationImage(image: scaledImage)
        }
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    // Todo: Crop imageView to square!
    
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
        return filtrationImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell

        let filtrationImage = filtrationImages[indexPath.row]
        switch filtrationImage.filterState {
        case .filtered:
            cell.imageView.image = filtrationImage.image
        case .noFilter:
            let filter = filters[indexPath.row]
            startFiltrationOperationForImage(filtrationImage, with: filter, at: indexPath) // in Operation.main 中执行将会被标记为.filtered
        }
        
        return cell
    }
    
    func startFiltrationOperationForImage(_ image: FiltrationImage, with filter: CIFilter, at indexPath: IndexPath) {
        if filtrationsInProgress.contains(indexPath) {
            return
        }
        let operation = ImageFiltrationOperation(image: image, filter: filter)
        
        filtrationsInProgress.insert(indexPath)
        filtrationQueue.addOperation(operation)
        
        operation.completionBlock = {
            if operation.isCancelled {
                return
            }
            DispatchQueue.main.async { // When they are done.
                self.filtrationsInProgress.remove(indexPath)
                self.filtersCollectionView.reloadItems(at: [indexPath])
            }
        }
        
    }
    
    
    
}



