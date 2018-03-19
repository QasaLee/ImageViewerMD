//
//  DataSource.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotosDataSource: NSObject, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private let fetchedResultsController: PhotosFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<Photo>, managedObjectContext context: NSManagedObjectContext, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.fetchedResultsController = PhotosFetchedResultsController(request: fetchRequest, context: context)
        super.init()
        fetchedResultsController.delegate = self // fetchedResultsController has been fledged with more funcs!!!
    }
    
    // MARK: -  UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = fetchedResultsController.object(at: indexPath)
        photoCell.photoView.image = photo.image
        return photoCell
    }
    
}


extension PhotosDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}


extension PhotosDataSource {
    var photos: [Photo] {
        guard let objects = fetchedResultsController.sections?.first?.objects as? [Photo] else { return [] }
        
        return objects
    }
}
