//
//  SortItemSelector.swift
//  PhotoEffects
//
//  Created by One on 27/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// this class is going to handle selection of a row in sorting tableView

class SortItemSelector<SortType: NSManagedObject>: NSObject, UITableViewDelegate {
    
    fileprivate let sortItems: [SortType]
    
    // storing tags
    var checkedItems: Set<SortType> = []
    
    init(sortItems: [SortType]) {
        self.sortItems = sortItems
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // user can select all tags (default) or a concrete tag
        switch indexPath.section {
        case 0:
            
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            // draw a checkmark in the cell
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                
                // removing checkmarks from all other cells
                
                let nextSection = indexPath.section.advanced(by: 1)
                
                let numberOfRowsInSubsequentSection = tableView.numberOfRows(inSection: nextSection)
                
                // looping every cell
                for row in 0..<numberOfRowsInSubsequentSection {
                    let indexPath = IndexPath(row: row, section: nextSection)
                    
                    // and removing checkmark
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = .none
                    
                    // reset checked items to empty
                    checkedItems = []
                }
            }
            
        case 1:
            
            // removing checkmarks from other cells
            let allItemsIndexPath = IndexPath(row: 0, section: 0)
            let allItemsCell = tableView.cellForRow(at: allItemsIndexPath)
            allItemsCell?.accessoryType = .none
            
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            // retreiving current item
            let item = sortItems[indexPath.row]
            
            // checking/unchecking the current cell
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                checkedItems.insert(item)
            } else if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checkedItems.remove(item)
            }
        default: break
        }
        
        //print(checkedItems.description)
    }
}
