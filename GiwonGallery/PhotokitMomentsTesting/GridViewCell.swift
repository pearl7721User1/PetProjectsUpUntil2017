//
//  GridViewCell.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {

    // imageView represents the view for a thumbnail image for an asset
    @IBOutlet var imageView: UIImageView!
    
    // If the asset's metadata indicates that it's a favorite asset, give this image view a heart image
    @IBOutlet var favoriteBadgeImageView: UIImageView!

    // Each view is assigned a unique identifier so that views don't mix up upon recycling
    var representedAssetIdentifier: String!
    
    // The thumbnail image for an asset
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }

    // The heart image for a favorite asset
    var favoriteBadgeImage: UIImage! {
        didSet {
            favoriteBadgeImageView.image = favoriteBadgeImage
        }
    }

    // The func is called upon collectionview recycling. A cell needs to remove its remnants before something new comes in.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isHidden = false
        imageView.image = nil
        favoriteBadgeImageView.image = nil
    }
}
