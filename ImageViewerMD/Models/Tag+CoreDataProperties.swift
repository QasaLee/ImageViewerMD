//
//  Tag+CoreDataProperties.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 4/1/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let descriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [descriptor]
        return request
    }

    @NSManaged public var name: String?
    /// This is a relationship!
    @NSManaged public var photos: Set<Photo>

}

extension Tag {
    static var entityName: String {
        return String(describing: Tag.self)
    }
    
    @nonobjc class func withName(_ name: String, in context: NSManagedObjectContext) -> Tag {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        let predicate = NSPredicate(format: "name==%@", name) // "name==%@" 指的是 @NSManaged public var name.
        request.predicate = predicate
        
        if let tag = try! context.fetch(request).first {
            return tag
        } else { // if doesn't exist, then create one.
            let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: context) as! Tag
            tag.name = name
            tag.photos = []
            return tag
        }
    }
}

// MARK: Generated accessors for photos
extension Tag {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
