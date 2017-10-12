//
//  MomentsViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

protocol MomentsViewCellControlDelegate {
    
    func undoCellSelection()
}

class MomentsViewController: UIViewController {

    // to off-screen the collection view if Photos permission is unavailable
    var theViewForUnavailablePermission = ViewForPermissionUnavailable()
    
    // asset collection groups
    var collectionFetchResult: PHFetchResult<PHAssetCollection>?
    
    // for caching assets once each one is fetched
    var assetFetchResultDictionary = Dictionary<Int, PHFetchResult<PHAsset>>()
    
    // for fetching assets
    let imageManager = PHImageManager()
    var thumbnailSize: CGSize!
    
    // for close-up view for an asset
    var detailViewController: DetailViewController?

    // copycat image view for view controller transition animation
    var snapshotView: UIImageView?
    
    // to remember the cell index for many uses
    var selectedCellIndexPath: IndexPath?
    
    // pre or post procedures for view controller transition animation
    var springUpPreVCTransitionClosure: (() -> ())!
    var springUpPostVCTransitionClosure: (() -> ())!
    var shrinkPreVCTransitionClosure: (() -> ())!
    var shrinkPostVCTransitionClosure: (() -> ())!
    
    // to set the collection view's focus to the last item for the first time only
    var viewDidLayoutSubviewsForTheFirstTime = true
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    // MARK: - View Cycle
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure the view and the navigation controller's setting
        self.view.backgroundColor = UIColor.clear
        
        navigationController?.isToolbarHidden = false
        navigationController?.delegate = self

        // register library instance to add change observer
        PHPhotoLibrary.shared().register(self)
        
        // customize the collection view's flow layout so that collection view cells have separator between them
        self.theCollectionView.collectionViewLayout = self.theCollectionView.flowLayout()
        
        // determine the size of the thumbnails and use it to request the images from the PHImageManager
        thumbnailSize = self.theCollectionView.thumbnailSize()
        
        // make sure if access to photos is permitted
        photosPermissionInspection()
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // manually set the view's layout so that it doesn't need to set its constraints for the sake of simplicity
        theViewForUnavailablePermission.frame = self.view.frame
    }
    
    override func viewDidLayoutSubviews() {
        
        // to set the collection view's focus to the last item. This should occur only once when the view is loaded for the first time
        if (viewDidLayoutSubviewsForTheFirstTime) {
            viewDidLayoutSubviewsForTheFirstTime = false
            
            let lastSection = theCollectionView.numberOfSections - 1
            let lastItem = theCollectionView.numberOfItems(inSection: lastSection) - 1
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            
            theCollectionView.scrollToItem(at: indexPath, at: [.left, .bottom], animated: false)
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View Reload
    func loadPhotos() {
        
        // fetch the asset collections from the library
        collectionFetchResult = getMomentsCollectionFetchResult()
        
        // remove the cache that has stored assets
        assetFetchResultDictionary.removeAll()
        
        // re-populate the collection view with new assets
        theCollectionView.reloadData()
    }

    
    // MARK: - Photos Permission
    func foregroundEntered() {
        
        // when the app state changes from background to foreground, inspect the photos permission state. if photos is not permitted, this view controller's view is locked.
        photosPermissionInspection()
    }
    
    func photosPermissionInspection() {
        
        switch (PHPhotoLibrary.authorizationStatus()) {
        case .authorized:

            if theViewForUnavailablePermission.superview != nil {
                theViewForUnavailablePermission.removeFromSuperview()
            }
            
            loadPhotos()
            
        default:
            
            if theViewForUnavailablePermission.superview == nil {
                self.view.insertSubview(theViewForUnavailablePermission, aboveSubview: theCollectionView)
            }
        }
    }
    
    // MARK: Helper Methods
    func createScreenShotView() -> UIView {
        // This func is called to get the window screen shot view. The screenshot is going to be the background of the DetailViewController's view only with the alpha value 0. If it is pulled, then it is revealed.
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imgView = UIImageView(image: screenshot)
        let view = UIView(frame: self.view.frame)
        imgView.frame = view.bounds
        view.addSubview(imgView)
        
        return view
    }
    
    func setVCTransitionClosures(cell: GridViewCell, detailVC: DetailViewController) {
        // This func is called to prepare pre or post view controller transition animation procedures. The procedures mostly involve hiding or undoing the views to maximize animation effect.
        
        springUpPreVCTransitionClosure = {() -> () in
            
            self.hideSelectedCell(true)
            detailVC.hideAllViews()
        }
        
        springUpPostVCTransitionClosure = {() -> () in
            
            detailVC.updateViewHiddenSetting()
        }
        
        shrinkPreVCTransitionClosure = {() -> () in
            
            detailVC.hideAllViews()
        }
        
        shrinkPostVCTransitionClosure = {() -> () in
            
            self.hideSelectedCell(false)
            self.selectedCellIndexPath = nil
        }
    }
    
    func hideSelectedCell(_ isHidden: Bool) {
        // This func is called to hide currently selected cell which is 'selectedCellIndexPath'.
        
        if let indexPath = selectedCellIndexPath {
            
            let selectedCell = theCollectionView.cellForItem(at: indexPath)
            selectedCell?.isHidden = isHidden
        }
        
    }
    
    func getAsset(at indexPath:IndexPath, from collectionFetchResult:PHFetchResult<PHAssetCollection>) -> PHAsset {
        
        // look up for an assetCollection using indexPath
        let assetCollection = collectionFetchResult.object(at: indexPath.section)
        
        // if it finds PHAsset fetchResult in the cache, get it immediately. Otherwise, fetch it from the library
        var assetFetchResult: PHFetchResult<PHAsset>!
        
        if assetFetchResultDictionary[indexPath.section] != nil {
            assetFetchResult = assetFetchResultDictionary[indexPath.section]
        }
        else {
            assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: PHFetchOptions())
            assetFetchResultDictionary[indexPath.section] = assetFetchResult
        }
        
        // get the asset that indexPath indicates
        let asset = assetFetchResult.object(at: indexPath.row)
        
        return asset
    }
}

extension MomentsViewController: MomentsViewCellControlDelegate {
    // This func is called to undo cell selection if any, and reload the collection view. This one is particularly being used to respond to 'deleting asset' signal coming from the DetailViewController.
    
    func undoCellSelection() {
        
        selectedCellIndexPath = nil
        loadPhotos()
    }
    
}

extension MomentsViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dequeue collectionview cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        // hide the cell if it's in selected state
        hideSelectedCell(true)
        
        if let collections = collectionFetchResult {
            
            // get asset from the collection fetch result
            let asset = getAsset(at: indexPath, from: collections)
            
            // if the asset is a favorite, mark the badge
            cell.favoriteBadgeImage = asset.isFavorite ? UIImage(named: "heartWhite.png") : nil
            
            // assign the cell the asset's unique identifier
            cell.representedAssetIdentifier = asset.localIdentifier
            
            // request an image for the asset from the PHCachingImageManager. The image size is set as 1.5 times thumbnail image size to optimize performance.
            imageManager.requestImage(for: asset, targetSize: CGSize(width:thumbnailSize.width*1.5, height:thumbnailSize.height*1.5), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                
                // The cell may have been recycled by the time this handler gets called;
                // set the cell's thumbnail image only if it's still showing the same asset.
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.thumbnailImage = image
                }
            })
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return the number of assets that fall into the same collection
        if let fetchResult = collectionFetchResult {
            let collection = fetchResult.object(at: section)
            return collection.estimatedAssetCount
            
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // return the number of collections
        if let fetchResult = collectionFetchResult {
            return fetchResult.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // load collection header view that reads time, date for each collection
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ViewHeader",
                                                                             for: indexPath)
            let label = headerView.viewWithTag(10) as! UILabel
            let collection = collectionFetchResult?.object(at: indexPath.section)
            
            if let startDate = collection?.startDate {
                
                let f = DateFormatter()
                f.dateStyle = .medium
                f.timeStyle = .medium
                
                label.text = f.string(from: startDate)
            }
            
            return headerView
            
        default:
            
            fatalError("Unexpected element kind")
        }
    }
}

extension MomentsViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        // instantiate the detailViewController to display the asset in full screen size
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("failed to instantiate DetailViewController")
        }
        
        if let collections = collectionFetchResult {
            
            // get the position and size of the selected cell
            guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { fatalError() }
            
            // set the cell's position from the window's point of view
            let cellRect = CGRect(origin:
                CGPoint(x:attributes.frame.origin.x, y:attributes.frame.origin.y - collectionView.contentOffset.y), size: attributes.frame.size)
            
            // create a copycat of the selected cell view with the same image
            snapshotView = UIImageView(frame: cellRect)
            snapshotView!.image = cell.thumbnailImage
            snapshotView!.contentMode = .scaleAspectFill
            
            print("cellRect:\(cellRect.origin.x) \(cellRect.origin.y) \(cellRect.size.width) \(cellRect.size.height)")
            
            // set the instance member to indicate the selected cell's index path
            selectedCellIndexPath = indexPath
            
            // get the asset that the image is originated from
            let asset = getAsset(at: indexPath, from: collections)
            
            // set what's necessary to function detail view controller and the transition animation effect
            detailVC.asset = asset
            detailVC.snapShotBgView = createScreenShotView()
            detailVC.delegate = self
            detailViewController = detailVC

            // set the instance members for them to supplement the SpringUpAnimator and ShrinkOffAnimator delegate methods
            setVCTransitionClosures(cell: cell, detailVC: detailViewController!)
            
            // push the detail view controller into the navigation stack
            self.navigationController?.pushViewController(detailViewController!, animated: true)
        }
        
    }
    
}

extension MomentsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // the return is selective to particular operation, view controllers
        if (operation == .push) && ((fromVC as? MomentsViewController) != nil) {
            let animator = SpringUpAnimator(delegate: self)
            return animator
        }
        
        if (operation == .pop) && ((toVC as? MomentsViewController) != nil) {
            let animator = ShrinkOffAnimator(delegate: self)
            return animator
        }
        
        return nil
    }
}

extension UICollectionView {
    
    func cellSize() -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        let spacing = self.spacing()
        
        let cellWidth = (screenSize.width - (spacing*3)) / 4
        let cellHeight = cellWidth
        
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func thumbnailSize() -> CGSize {
        
        let scale = UIScreen.main.scale
        let cellSize = self.cellSize()
        let thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        return thumbnailSize
    }
    
    func flowLayout() -> UICollectionViewFlowLayout {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = self.cellSize()
        flowLayout.minimumLineSpacing = self.spacing()
        flowLayout.minimumInteritemSpacing = self.spacing()
        flowLayout.headerReferenceSize = CGSize(width: 50, height: 50)
        return flowLayout
    }
    
    func spacing() -> CGFloat {
        return 1.5
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension MomentsViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        DispatchQueue.main.sync {
            
            // if changes occur in the library, re-fetch it and re-populate the collection view
            self.loadPhotos()
        }
    }
}
