//
//  FilteredImageBuilder.swift
//  PhotoEffects
//
//  Created by One on 26/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

final class FilteredImageBuilder {
    
    fileprivate struct PhotoFilter {
        
        // names of filters that will be applied to an Image (to prevent stringly typed mistakes)
        static let ColorClamp = "CIColorClamp"
        static let ColorControls = "CIColorControls"
        static let PhotoEffectInstant = "CIPhotoEffectInstant"
        static let PhotoEffectProcess = "CIPhotoEffectProcess"
        static let PhotoEffectNoir = "CIPhotoEffectNoir"
        static let Sepia = "CISepiaTone"
        
        
        static func defaultFilters() -> [CIFilter] {
            
            // filter settings
            
            // Color Clamp
            let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
            // x,y,z,w = rgb and alpha
            colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            // using KVC because can't call any properties on filters
            colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // Color Controls
            let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // Photo Effects
            let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
            
            // Sepia
            let sepia = CIFilter(name: PhotoFilter.Sepia)!
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
        }
    }
    
    fileprivate let image: UIImage
    
    // context is used to draw the output image
    // global context to prevent creating it for each image and slowing down overall process
    fileprivate let context: CIContext
    
    
    init(context: CIContext, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    // applying default filters
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    // takes an array of filters and returns an array of images
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(self.image, withFilter: $0) }
    }
    
    // takes an image, apply filter, and return changed image
    func image(_ image: UIImage, withFilter filter: CIFilter) -> CIImage {
        
        // converting image to CIImage
        let inputImage = image.ciImage ?? CIImage(image: image)!
        
        // set image to be filtered
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        // applying filter, and returning modified image
        let outputImage = filter.outputImage!
        
        // using graphics
        return outputImage.cropping(to: inputImage.extent)
    }
}
