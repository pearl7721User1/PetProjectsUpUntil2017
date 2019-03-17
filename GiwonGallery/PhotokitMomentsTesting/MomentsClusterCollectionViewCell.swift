//
//  MomentsClusterCollectionViewCell.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 10/01/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit

class MomentsClusterCollectionViewCell: UICollectionViewCell {
    
    // imageView represents the view for a thumbnail image for an asset
    @IBOutlet var imageView: UIImageView!
    
    // Each view is assigned a unique identifier so that views don't mix up upon recycling
    var representedAssetIdentifier: String!
    
    // The thumbnail image for an asset
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    // The func is called upon collectionview recycling. A cell needs to remove its remnants before something new comes in.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isHidden = false
        imageView.image = nil
    }
}
