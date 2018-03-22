//
//  PhotoListController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import UIKit
import CoreData

class PhotoListController: UIViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    let context = CoreDataStack().managedObjectContext
    
    lazy var dataSource: PhotosDataSource = {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        return PhotosDataSource(fetchRequest: request, managedObjectContext: context, collectionView: photosCollectionView)
    }()
    
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self // By self, sets delegate more power!
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.dataSource = dataSource
    }
    
    @IBAction func launchCamera(_ sender: Any) {
        photoPickerManager.presentPhotoPicker(animated: true) // Launch photoPickerManager
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            if let cell = sender as? UICollectionViewCell, let indexPath = photosCollectionView.indexPath(for: cell), let photoPageController = segue.destination as? PhotoPageController {
                
                photoPageController.photos = dataSource.photos
                photoPageController.indexOfCurrentPhoto = indexPath.row
            }
        }
    }
}

extension PhotoListController: PhotoPickerManagerDelegate {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
//        let _ = Photo.with(image, in: context)
//        context.saveChanges()
        
        manager.dismissPhotoPicker(animated: true) {
            guard let photoFilterController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoFilterController") as? PhotoFilterController else { return }
            photoFilterController.photoImage = image
            let navController = UINavigationController(rootViewController: photoFilterController)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
    
}
