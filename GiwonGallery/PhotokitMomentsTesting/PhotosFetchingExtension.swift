//
//  PHAssetFetchModel.swift
//  PhotoKitTesting1
//
//  Created by SeoGiwon on 12/4/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

extension UIViewController {
    
    func getMomentsCollectionFetchResult() -> PHFetchResult<PHAssetCollection> {
        
        // fetch asset groups from the library
        let collectionsFetchResult = PHAssetCollection.fetchMoments(with: PHFetchOptions())
        return collectionsFetchResult
    }
}
