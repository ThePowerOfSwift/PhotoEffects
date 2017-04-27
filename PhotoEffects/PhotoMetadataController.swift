//
//  PhotoMetadataController.swift
//  PhotoEffects
//
//  Created by One on 26/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController {
    
    fileprivate var locationManager: LocationManager!
    fileprivate var location: CLLocation?
    
    fileprivate let photo: UIImage
    
    init(photo: UIImage) {
        self.photo = photo
        // to present groups of rows. Headers don't scroll along with the rows
        super.init(style: .grouped)
    }
    
    // to prevent using Story Board
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Metadata fields
    
    // photo image of a cell
    fileprivate lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // calculating ImageView height to it's width
    fileprivate lazy var imageViewHeight: CGFloat = {
        let imgFactor = self.photoImageView.frame.size.height/self.photoImageView.frame.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * imgFactor
    }()
    
    // to present location information
    fileprivate lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить местоположение"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // indicator while loading location information in second row
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // for user's ability to add tags (string) to a photo.
    fileprivate lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "лето, отдых"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a button to save the metadata
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView DataSource

extension PhotoMetadataController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // capturing image, location and tags = 3
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // each section will contain only one row
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none // preventing selection highlight
        
        // according to static TableView, we can switch to all of three sections and customize data
        switch (indexPath.section, indexPath.row) {
        
        case (0, 0):
            
            cell.contentView.addSubview(photoImageView)
            
            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
                ])
            
        case (1, 0):
            
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
            
        case (2, 0):
            
            cell.contentView.addSubview(tagsTextField)
            
            NSLayoutConstraint.activate([
                tagsTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                tagsTextField.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                tagsTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                tagsTextField.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                ])
        default: break
        }
        
        return cell
    }
}

// MARK: - Helper Methods
extension PhotoMetadataController {
    func tagsFromTextField() -> [String] {
        guard let tags = tagsTextField.text else { return [] }
        
        // iterates through the characters. If they are separated with "," - split the words.
        let commaSeparatedSubSequences = tags.characters.split { $0 == "," }
        let commaSeparatedStrings = commaSeparatedSubSequences.map(String.init)
        // lowercase all words(tags) to ease the comparison
        let lowercaseTags = commaSeparatedStrings.map { $0.lowercased() }
        
        // removing all white spaces
        return lowercaseTags.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    }
}

// MARK: - Persistence
extension PhotoMetadataController {
    @objc fileprivate func savePhotoWithMetadata() {
        
        // saving photo with location and dags using Core Data
        let tags = tagsFromTextField()
        Photo.photoWith(photo, tags: tags, location: location)
        
        CoreDataController.save()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension PhotoMetadataController {
    
    // for image to fill the entire row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0): return imageViewHeight
        default: return tableView.rowHeight
        }
    }
    
    // to add location by tap on the row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            locationLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            locationManager = LocationManager()
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.locationLabel.isHidden = false
                    
                    guard let name = placemark.name, let city = placemark.locality, let area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                }
            }
        default: break
        }
    }
    
    // header for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Photo"
        case 1: return "Enter a location"
        case 2: return "Enter tags"
        default: return nil
        }
    }
}

