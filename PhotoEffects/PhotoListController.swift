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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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


