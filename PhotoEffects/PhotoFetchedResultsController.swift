//
//  PhotoFetchedResultsController.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    fileprivate let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        // once the class is initialized, immediately execute fetch
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error)")
        }
    }
    
    // call this method every time when dismissing the sort controller
    func performFetch(withPredicate predicate: NSPredicate?) {
        // deleting all the cache
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        fetchRequest.predicate = predicate
        // go get the new data
        executeFetch()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    // when the content is changed - reload collection view
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}
