//
//  PhotoFilterController.swift
//  PhotoEffects
//
//  Created by One on 26/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    // image that user selected in a previous step
    fileprivate var mainImage: UIImage {
        didSet {
            // to observe when filter should be applied and change main image
            photoImageView.image = mainImage
        }
    }
    
    fileprivate let context: CIContext
    fileprivate let eaglContext: EAGLContext
    
    // to display the selected photo in bigger size on the screen
    fileprivate let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // select a filter label
    fileprivate lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()
    
    // collection view to display different filters
    lazy var filtersCollectionView: UICollectionView = {
        // firstly, establish a flowLayout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 1000
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .black
        
        // register a cell (because no Story Board is used)
        collectionView.register(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.reuseIdentifier)
        
        // collection view settings
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // data sourse
    fileprivate lazy var filteredImages: [CIImage] = {
        // passing an image to work with
        let filteredImageBuilder = FilteredImageBuilder(context: self.context, image: self.mainImage)
        // filtered images
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        self.mainImage = image
        self.context = context
        self.eaglContext = eaglContext
        
        self.photoImageView.image = self.mainImage
        super.init(nibName: nil, bundle: nil)
    }
    
    // if the app will try to look for story board - immediate crash. Ordinarry behaviour
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.dismissPhotoFilterController))
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activate([
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 200.0),
            filtersCollectionView.topAnchor.constraint(equalTo: filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        
        let ciImage = filteredImages[indexPath.row]
        
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoFilterController: UICollectionViewDelegate {
    
    // actions when cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // what image was selected
        let ciImage = filteredImages[indexPath.row]
        
        // changing image with new and applied effects
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        mainImage = UIImage(cgImage: cgImage!)
    }
    
}

// MARK: - Navigation Buttons actions

extension PhotoFilterController {
    @objc fileprivate func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func presentMetadataController() {
        
    }
}
