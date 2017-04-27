//
//  PhotoDataSource.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// this class acts as a Data Source for the collection view in PhotoListController

class PhotoDataSource: NSObject {
    
    fileprivate let collectionView: UICollectionView
    fileprivate let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    fileprivate let fetchedResultsController: PhotoFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
        
        super.init()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0}
        
        return section.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        cell.imageView.image = photo.photoImage
        
        return cell
    }
}