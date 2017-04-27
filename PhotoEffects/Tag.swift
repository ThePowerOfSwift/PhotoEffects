//
//  Tag.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {

    // describe an entity name    
    static let entityName = "\(Tag.self)"
    
    // class method to ease creation of tag object
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        
        tag.title = title
        
        return tag
    }
}

extension Tag {
    @NSManaged var title: String
}

