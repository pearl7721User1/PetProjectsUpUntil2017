//
//  MomentsClusterViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 07/01/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsClusterViewController: UIViewController, UICollectionViewDataSource {

    // to set the collection view's focus to the last item for the first time only
    var viewDidLayoutSubviewsForTheFirstTime = true
    
    // asset collection groups
    var collectionListFetchResult: PHFetchResult<PHCollectionList>? {
        get {
            return PhotosViewModel.shared.momentsClusterCollectionListFetchResult
        }
    }
    /*
    var assetFetchResults: [PHFetchResult<PHAsset>] {
        get {
            return PhotosViewModel.shared.momentsClusterAssetFetchResults
        }
    }
    */
    
    var collectionListCounts: [Int]? {
        get {
            return PhotosViewModel.shared.momentsClusterCollectionViewInitialItemNumbers
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        PHPhotoLibrary.shared().register(self)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // to set the collection view's focus to the last item. This should occur only once when the view is loaded for the first time
        if (viewDidLayoutSubviewsForTheFirstTime) {
            viewDidLayoutSubviewsForTheFirstTime = false
            /*
            let lastSection = collectionView.numberOfSections - 1
            let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            
            collectionView.scrollToItem(at: indexPath, at: [.left, .bottom], animated: false)
            */
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dequeue collectionview cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? MomentsClusterCollectionViewCell else { fatalError("failed to dequeue MomentsClusterCollectionViewCell") }
        
/*
        let assetFetchResult = assetFetchResults[indexPath.section]
        let phAsset = assetFetchResult.object(at: indexPath.row)
        
        // assign the cell the asset's unique identifier
        cell.representedAssetIdentifier = phAsset.localIdentifier
        
        // request an image for the asset from the PHCachingImageManager. The image size is set as 1.5 times thumbnail image size to optimize performance.
        imageManager.requestImage(for: phAsset, targetSize: CGSize(width:40, height:40), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == phAsset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
*/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        let maxIndex = assetFetchResults.count - 1
        if maxIndex < section {
            return 0
        }
        else {
            let assetFetchResult = assetFetchResults[section]
            return assetFetchResult.count
        }*/
        
        if let collectionListCounts = collectionListCounts {
            return collectionListCounts.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let collectionListFetchResult = collectionListFetchResult {
            return collectionListFetchResult.count
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // load collection header view that reads time, date for each collection
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ViewHeader",
                                                                             for: indexPath)
            let label = headerView.viewWithTag(10) as! UILabel
            let collectionList = collectionListFetchResult?.object(at: indexPath.section)
            
            if let startDate = collectionList?.startDate,
                let endDate = collectionList?.endDate {
                
                let f = DateFormatter()
                f.dateStyle = .medium
                f.timeStyle = .medium
                
                label.text = "\(f.string(from: startDate)) - \(f.string(from:endDate))"
            }
            
            return headerView
            
        default:
            
            fatalError("Unexpected element kind")
        }
    }

}

// MARK: PHPhotoLibraryChangeObserver
extension MomentsClusterViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        DispatchQueue.main.sync {
            
          
        }
    }
}


