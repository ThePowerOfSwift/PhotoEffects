//
//  MediaPickerManager.swift
//  PhotoEffects
//
//  Created by One on 26/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit
import MobileCoreServices

// for passing image reguardless of what controller or object works with it. Delegation pattern
protocol MediaPickerManagerDelegate: class { // only classes can work with it
    func mediaPickerManager(_ manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    // for camera or photo library usage
    fileprivate let imagePickerController = UIImagePickerController()
    // for dependency injection
    fileprivate let presentingViewController: UIViewController
    
    // to assign the delegate. Weak to prevent reference cycle
    weak var delegate: MediaPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        
        // dependency injection. to show itself in viewController
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        // if camera is available (not in simulator)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            // for front camera
            imagePickerController.cameraDevice = .front
        } else {
            // else use photo library
            imagePickerController.sourceType = .photoLibrary
        }
        // for only photos, except videos
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    // present/dismiss new controller
    func presentImagePickerController(animated: Bool) {
        presentingViewController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool, completion: @escaping (() -> Void)) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
}


extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // this method helps figure out if user picked an image, and what image was chosen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // using created delegation. Now we know what image was chosen.
        delegate?.mediaPickerManager(self, didFinishPickingImage: image)
    }
}
