//
//  PhotosViewModel.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/01/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class PhotosViewModel {

    enum ValidModels: String {
        case momentsClusterAvailability
    }
    
    private (set) static var shared: PhotosViewModel = PhotosViewModel()
    
    
    func startFetching() {
        
        
        let group = DispatchGroup()
        group.enter()
        
        
        DispatchQueue.global(qos: .default).async {
            
            self.fetchForMomentsClusterCollectionViewSectionAndItem()
            group.leave()
        }
        
        group.notify(queue: .global()) {
            self.isMomentsClusterViewControllerAvailable = true
        }
    }
    
    // MomentsCluster
    var momentsClusterCollectionListFetchResult: PHFetchResult<PHCollectionList>?
    var momentsClusterCollectionViewInitialItemNumbers: [Int]?
    
    
    var momentsClusterAssetFetchResults = [PHFetchResult<PHAsset>]()
    private (set) var isMomentsClusterViewControllerAvailable = false {
        didSet {
            
            NotificationCenter.default.post(
                name: Notification.Name(ValidModels.momentsClusterAvailability.rawValue),
                object: nil, userInfo:nil)
        }
    }
    
    private func momentsClusterSectionItems() {
        let ascendingOrderStartDateFetchOption = PHFetchOptions()
        ascendingOrderStartDateFetchOption.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
        
        momentsClusterCollectionListFetchResult = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: ascendingOrderStartDateFetchOption)
        
        
        momentsClusterCollectionListFetchResult?.enumerateObjects({ (collectionList, index, stop) in
            
            // create collection fetch result
            let collectionFetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchMoments(inMomentList: collectionList, options: PHFetchOptions())
            
            
            // create identifiers
            //            var workingIdentifiers = [String]()
            var phAssetCountForList = 0
            
            // enumerate over the collection fetch result
            collectionFetchResult.enumerateObjects({ (collection, index, stop) in
                
                phAssetCountForList += collection.estimatedAssetCount
            
            })
            
            self.momentsClusterCollectionViewInitialItemNumbers?.append(phAssetCountForList)
            
        })
    }
    
    private func fetchForMomentsClusterCollectionViewSectionAndItem() {
        
        let ascendingOrderStartDateFetchOption = PHFetchOptions()
        ascendingOrderStartDateFetchOption.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
        
        momentsClusterCollectionListFetchResult = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: ascendingOrderStartDateFetchOption)
        
        
        momentsClusterCollectionListFetchResult?.enumerateObjects({ (collectionList, index, stop) in
            
            // create collection fetch result
            let collectionFetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchMoments(inMomentList: collectionList, options: PHFetchOptions())
            
            
            // create identifiers
//            var workingIdentifiers = [String]()
            var phAssetCountForList = 0
            
            // enumerate over the collection fetch result
            collectionFetchResult.enumerateObjects({ (collection, index, stop) in
                
                phAssetCountForList += collection.estimatedAssetCount
                /*
                // create phasset fetch result
                let assetFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: PHFetchOptions())
                
                // enumerate over the phasset fetch result
                assetFetchResult.enumerateObjects({ (phAsset, index, stop) in
                    workingIdentifiers.append(phAsset.localIdentifier)
                })
                */
            })
            
            print(phAssetCountForList)
            
            self.momentsClusterCollectionViewInitialItemNumbers?.append(phAssetCountForList)
            
            /*
            // create a phasset fetch result
            let assetFetchResultForAList = PHAsset.fetchAssets(withLocalIdentifiers: workingIdentifiers, options: PHFetchOptions())
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            
            
            
            // append
            self.momentsClusterAssetFetchResults.append(assetFetchResultForAList)
            */
        })
    }
    
    
    
}
