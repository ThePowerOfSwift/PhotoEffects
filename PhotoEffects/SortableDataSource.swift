//
//  SortableDataSource.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CustomTitleConvertible {
    // when sortlist loads, it needs a title to inform the user
    var title: String { get }
}

extension Tag: CustomTitleConvertible {}

// generic type. For ability to sort not only by tags, but location or other
class SortableDataSource<SortType: CustomTitleConvertible>: NSObject, UITableViewDataSource where SortType: NSManagedObject {
    
    // to retrieve data
    fileprivate let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    // for passing to PhotoListController
    var results: [SortType] {
        return fetchedResultsController.fetchedObjects as! [SortType]
    }
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        // immediately fetch data when initialized
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // because there would be two sections - "Tags" header and current tags
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return fetchedResultsController.fetchedObjects?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "sortableItemCell")
        cell.selectionStyle = .none
        
        switch (indexPath.section, indexPath.row) {
        case (0,0) :
            cell.textLabel?.text = "All \(SortType.self)s"
            cell.accessoryType = .checkmark
        case (1,_):
            
            guard let sortItem = fetchedResultsController.fetchedObjects?[indexPath.row] as? SortType else {
                break
            }
            
            cell.textLabel?.text = sortItem.title
        default: break
        }
        
        return cell
    }
}
