//
//  Photo+CoreDataProperties.swift
//  ImageViewerMD
//
//  Created by M78的星际人士 on 3/5/18.
//  Copyright © 2018 M78的星际人士. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Photo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @NSManaged public var creationDate: NSDate
    @NSManaged public var imageData: NSData
    @NSManaged public var caption: String?
    @NSManaged public var tags: Set<Tag>
}

extension Photo {
    static var entityName: String {
        return String(describing: Photo.self)
    }
    
    @nonobjc class func with(_ image: UIImage, caption: String?, tags: [String], in context: NSManagedObjectContext) -> Photo { // static method
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: context) as! Photo
        
        photo.creationDate = Date() as NSDate
        photo.imageData = UIImageJPEGRepresentation(image, 1.0)! as NSData
        
        photo.caption = caption
        if !tags.isEmpty {
            let savedTags: [Tag] = tags.map { (name) -> Tag in
                let tag = Tag.withName(name, in: context)
                tag.photos.insert(photo)
                return tag
            }
            photo.tags = Set(savedTags)
        }
        
        return photo
    }
}

extension Photo {
    var image: UIImage {
        return UIImage(data: self.imageData as Data)!
    }
}
