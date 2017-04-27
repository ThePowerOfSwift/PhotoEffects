//
//  ViewController.swift
//  PhotoEffects
//
//  Created by One on 17/03/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {
    
    // add button to the screen
    // creating, initializing and customizing simultaneousely in a closure and calling it
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Camera", for: UIControlState())
        button.tintColor = .white
        //button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        button.backgroundColor = UIColor(red: 40/255.0, green: 132/255.0, blue: 205/255.0, alpha: 1.0)
        
        // button is tapped and it executes a method
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)
        
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        // photoListController as a delegate to MediaPickerManager to pass selected photo from library
        manager.delegate = self
        return manager
    }()
    
    // loading saved photos
    lazy var dataSource: PhotoDataSource = {
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView: self.collectionView)
    }()
    
    // collection view with fetched (Core Data) photos
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let paddingDistance: CGFloat = 10.0
        let itemSize = (screenWidth - paddingDistance)/2.0
        
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .black
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        // to fill collection view with photos and adjust spacing
        collectionView.dataSource = dataSource
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }
    
    // MARK: - Image Picker Controller
    
    @objc fileprivate func presentImagePickerController() { // @objc because method of selector must be exposed as obj-c
        // presenting camera viewController
        mediaPickerManager.presentImagePickerController(animated: true)
    }
}


// MARK: - MediaPickerManagerDelegate

extension PhotoListController: MediaPickerManagerDelegate {
    func mediaPickerManager(_ manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        // taking selected photo and building some functionality to filter an image
        
        // using OpenGL for faster loading
        let eaglContext = EAGLContext(api: .openGLES2)
        let ciContext = CIContext(eaglContext: eaglContext!)
        
        // image selected
        let photoFilterController = PhotoFilterController(image: image, context: ciContext, eaglContext: eaglContext!)
        
        // when image is selected, moving forward to photoFilterController
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        manager.dismissImagePickerController(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - Navigation
extension PhotoListController {
    
    fileprivate func setupNavigationBar() {
        // button for sorting
        let sortTagsButton = UIBarButtonItem(title: "Tags", style: .plain, target: self, action: #selector(PhotoListController.presentSortController))
        // to pass more that one bar button item
        navigationItem.setRightBarButtonItems([sortTagsButton], animated: true)
    }
    
    @objc fileprivate func presentSortController() {
        
        // getting all tags by generic type "Tag"
        let tagDataSource = SortableDataSource<Tag>(fetchRequest: Tag.allTagsRequest, managedObjectContext: CoreDataController.sharedInstance.managedObjectContext)
        
        let sortItemSelector = SortItemSelector(sortItems: tagDataSource.results)
        
        let sortController = PhotoSortListController(dataSource: tagDataSource, sortItemSelector: sortItemSelector)
        
        sortController.onSortSelection = { checkedItems in
            
            // NSPredicate for search and filtering fetched data
            if !checkedItems.isEmpty {
                
                var predicates = [NSPredicate]()
                // grab each tag and create a predicate from it
                for tag in checkedItems {
                    // tags.tigle is the keypath to the photos entity. It's going to filter on entity photos.tags.title. %K - keypath
                    let predicate = NSPredicate(format: "%K CONTAINS %@", "tags.title", tag.title)
                    predicates.append(predicate)
                }
                
                // compoundPredicate is a series of predicates with a rule of how to deal with subpredicates
                // this means that photos that match any of the tags individually will be included in the result set 
                let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
                self.dataSource.performFetch(withPredicate: compoundPredicate)
            } else {
                self.dataSource.performFetch(withPredicate: nil)
            }
        }
        
        let navigationController = UINavigationController(rootViewController: sortController)
        
        present(navigationController, animated: true, completion: nil)
    }
}


