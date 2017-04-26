//
//  FilteredImageCell.swift
//  PhotoEffects
//
//  Created by One on 26/04/2017.
//  Copyright © 2017 One. All rights reserved.
//

import UIKit
import GLKit

class FilteredImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FilteredImageCell.self)
    
    // using GLKit and GLKView instead of UIView for faster processing
    var eaglContext: EAGLContext!
    var ciContext: CIContext!
    
    lazy var glkView: GLKView = {
        let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    var image: CIImage!
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        contentView.addSubview(glkView)
        glkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            glkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glkView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            glkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            glkView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            ])
    }
}

extension FilteredImageCell: GLKViewDelegate {
    
    // renders the drawing in the actual view
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        // define rectangle for space to draw in a collectionView cell
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        let drawableRect = CGRect(origin: CGPoint.zero, size: drawableRectSize)
        
        ciContext.draw(image, in: drawableRect, from: image.extent)
    }
}
