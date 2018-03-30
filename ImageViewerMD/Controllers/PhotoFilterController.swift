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

    
    let queue = OperationQueue()
    
    let eaglContext = EAGLContext(api: .openGLES3) //iOS 7+
    var context: CIContext!
    /// Which is huge(original)!
    var photoImage: UIImage?
    // Todo: Crop imageView to square!
    var selectedFilter: CIFilter?
    
    private lazy var filteredImages: [CIImage] = {
        guard let image = self.photoImage else { return [] }
        if context == nil {
            print("👉👉👉context in PFltrC is nil!!!")
            return []
        }
        let filteredImageBuilder = FilteredImageBuilder(image: image)
        return  filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    /// Which is smaller!
    lazy var displayPhoto: UIImage? = {
        guard let image = photoImage else { return nil }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let screenWidth = UIScreen.main.bounds.width
        let scaleRatio = screenWidth / imageWidth
        let scaledHeight = scaleRatio * imageHeight
        let size = CGSize(width: screenWidth, height: scaledHeight)
        
        return image.resized(to: size)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.image = photoImage
        imageView.image = displayPhoto
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        setupNavigation()
    }
    
    func setupNavigation() {
        // an action selector, which identifies the method to be invoked, and a target, which is the object to receive the message. The message sent when the event occurs is called an action message.
        // Target is typically a custom controller that handles the action message in an application-specific way.
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPhotoFilterController))
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "NeXt", style: .done, target: self, action: #selector(launchPhotoMetadataController)) // ".done": The style for a done button—for example, a button that completes some task and returns to the previous view.
        navigationItem.rightBarButtonItem = nextButton
    }
    
    
    @objc func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func launchPhotoMetadataController() {
        guard let photoMetadataController = storyboard?.instantiateViewController(withIdentifier: "PhotoMetadataController") as? PhotoMetadataController else { return }
        
        photoMetadataController.displayPhoto = imageView.image
        photoMetadataController.photo = photoImage
        photoMetadataController.filter = selectedFilter
        
        navigationController?.pushViewController(photoMetadataController, animated: true)
        
    }
}

extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Debug
        print("👉👉👉There are \(filteredImages.count) images applied to filters.")
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


extension PhotoFilterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = PhotoFilter.defualtFilters[indexPath.row]
        selectedFilter = filter
        
        let image = FiltrationImage(image: displayPhoto!)
        let operation = ImageFiltrationOperation(image: image, filter: filter)
        
        operation.completionBlock = {
            if operation.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = operation.filtrationImage.image
            }
        }
        
        queue.addOperation(operation)
        
    }
}











