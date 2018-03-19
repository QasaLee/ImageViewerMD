//
//  CoreDataStack.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    private lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "ImageViewerMD")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("LoadPersistentStore fails due to: \(error), \(error.userInfo).")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
       let container = self.persistentContainer
        return container.viewContext
    }()
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Couldn't save due to: \(error.localizedDescription).")
            }
        }
    }
}
