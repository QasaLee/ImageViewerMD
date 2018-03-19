//
//  PhotosFetchedResultsController.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import CoreData

class PhotosFetchedResultsController: NSFetchedResultsController<Photo> {
    
    init(request: NSFetchRequest<Photo>, context: NSManagedObjectContext) {
        super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            fatalError("Couldn't fetch due to: \(error.localizedDescription)")
        }
    }
}

