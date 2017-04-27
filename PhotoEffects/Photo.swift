//
//  Photo.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Photo: NSManagedObject {
    
    // describe an entity name
    static let entityName = "\(Photo.self)"
    
    // to display all previously saved photos
    static var allPhotosRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Photo.entityName)
        // sorting photos by date in ascending order
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }()
    
    // photo with only image (whithout tags and location)
    class func photo(withImage image: UIImage) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        
        // current date when photo created
        photo.date = Date().timeIntervalSince1970
        // converting image from UIImage instance to NSData instance
        photo.image = UIImageJPEGRepresentation(image, 1.0)!
        
        return photo
    }
    
    // photo with tags and location
    class func photoWith(_ image: UIImage, tags: [String], location: CLLocation?) {
        let photo = Photo.photo(withImage: image)
        
        // use methods below
        photo.addTags(tags)
        photo.addLocation(location)
    }
    
    // add a single tag to a photo
    func addTag(withTitle title: String) {
        let tag = Tag.tag(withTitle: title)
        tags.insert(tag)
    }
    
    // add array of tags to a photo
    func addTags(_ tags: [String]) {
        for tag in tags {
            addTag(withTitle: tag)
        }
    }
    
    // add location to a photo
    func addLocation(_ location: CLLocation?) {
        if let location = location {
            let photoLocation = Location.locationWith(location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = photoLocation
        }
    }
}

extension Photo {
    
    // attributes as computed properties
    @NSManaged var date: TimeInterval    // storing as Double unix time
    @NSManaged var image: Data
    @NSManaged var tags: Set<Tag>
    @NSManaged var location: Location?
    
    // for passing others
    var photoImage: UIImage {
        return UIImage(data: image)!
    }
}
