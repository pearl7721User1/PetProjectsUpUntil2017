//
//  DetailViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 1/30/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import AVFoundation

class DetailViewController: UIViewController {

    // for the asset of live photo type
    var livePhotoView: PHLivePhotoView = PHLivePhotoView()
    
    // for the asset of static image, video type
    var imageView: UIImageView = UIImageView()
    
    // the copycat image of the asset for the sake of dismiss animation
    var snapShotImgView: UIImageView!

    // temporary variable to remember the point that the drag occurs
    var panInitialPointInView: CGPoint!
    
    // snapshot of the previous viewcontroller's window
    var snapShotBgView: UIView!
    
    // asset to display in either livePhotoView or imageView
    var asset: PHAsset!
    var delegate: MomentsViewCellControlDelegate?

    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var space: UIBarButtonItem!
    @IBOutlet var trashButton: UIBarButtonItem!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    fileprivate var playerLayer: AVPlayerLayer!
    fileprivate var isPlayingHint = false
    
    // MARK: View Cycle, Constraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view hierarchy
        self.view.addSubview(livePhotoView)
        self.view.addSubview(imageView)
        self.view.addSubview(snapShotBgView)
        
        // setup view constraints
        setupViewConstraints()
        
        // setup pan gesture recognizer
        setupPanGesture()
        
        // setup configuration for subviews
        snapShotBgView.isUserInteractionEnabled = false
        snapShotBgView.alpha = 0.0
        
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFit
        livePhotoView.frame = UIScreen.main.bounds
        livePhotoView.delegate = self
        
        PHPhotoLibrary.shared().register(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateButtons()
        updateImage()
        setSnapshotImgView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func setupViewConstraints() {
        // set constraints for all subviews
        
        snapShotBgView.translatesAutoresizingMaskIntoConstraints = false
        snapShotBgView.topAnchor.constraint(equalTo: snapShotBgView.superview!.topAnchor).isActive = true
        snapShotBgView.leftAnchor.constraint(equalTo: snapShotBgView.superview!.leftAnchor).isActive = true
        snapShotBgView.rightAnchor.constraint(equalTo: snapShotBgView.superview!.rightAnchor).isActive = true
        snapShotBgView.bottomAnchor.constraint(equalTo: snapShotBgView.superview!.bottomAnchor).isActive = true
        
        livePhotoView.translatesAutoresizingMaskIntoConstraints = false
        livePhotoView.topAnchor.constraint(equalTo: livePhotoView.superview!.topAnchor).isActive = true
        livePhotoView.leftAnchor.constraint(equalTo: livePhotoView.superview!.leftAnchor).isActive = true
        livePhotoView.rightAnchor.constraint(equalTo: livePhotoView.superview!.rightAnchor).isActive = true
        livePhotoView.bottomAnchor.constraint(equalTo: livePhotoView.superview!.bottomAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: imageView.superview!.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageView.superview!.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor).isActive = true
    }
    
    
    // MARK: Pan Gesture
    func setupPanGesture() {
        
        // Pan gesture is added either in imageView or livePhotoView according to the asset type.
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        
        if asset.mediaSubtypes.contains(.photoLive) {
            livePhotoView.addGestureRecognizer(panGR)
        } else {
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(panGR)
        }
        
        
    }
    
    func panHandler(_ sender: UIPanGestureRecognizer) {
        
        guard let theGestureView = sender.view else { return }
        
        // Learn which direction and distance drag occured. Translation value then must be set as zero point so that each time this handler function is called it doesn't accumulate.
        let translation = sender.translation(in: theGestureView)
        
        switch sender.state {
            
        case .began:
            
            // the point that thd drag starts has to be stored 
            panInitialPointInView = theGestureView.center
            
            // snapShotImgView is going to be the one who reacts to dragging instead of the target view. The target view must be set as hidden at this point.
            hideAllViews()
            self.view.addSubview(snapShotImgView)
            
        case .changed:
            
            // move snapShotImgView
            snapShotImgView.center = CGPoint(x:snapShotImgView.center.x + translation.x, y:snapShotImgView.center.y + translation.y);
            
            sender.setTranslation(CGPoint(x:0,y:0), in: theGestureView)
            
            // snapShotImgView's alpha value, navigation bar's are adjusted according to how many distances snapShotImgView moved
            let snapshotBgAlphaValue = snapshotBgAlpha(initPoint: panInitialPointInView, referenceValue: self.view.frame.size.height / 2.0, currentPoint: snapShotImgView.center)
            
            self.navigationController?.navigationBar.alpha = 1.0 - snapshotBgAlphaValue
            self.snapShotBgView.alpha = snapshotBgAlphaValue
            
        case .cancelled, .failed, .ended:
            
            // when the dragging ends, navigation bar's alpha value must go back to normal.
            self.navigationController?.navigationBar.alpha = 1.0
            
            // based on the threshold, it determines whether the view controller should dismiss or not
        if shouldPanFastForward(initPoint: panInitialPointInView, referenceValue: self.view.frame.size.height / 2.0, currentPoint: snapShotImgView.center) {
            
            self.snapShotImgView.removeFromSuperview()
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.snapShotImgView.center = self.view.center
                self.snapShotBgView.alpha = 0.0
            }, completion: { (finished) in
                self.snapShotImgView.removeFromSuperview()
                self.updateViewHiddenSetting()
            })
        }
            
        default: break
            
        }
    }
    
    func shouldPanFastForward(initPoint: CGPoint, referenceValue: CGFloat, currentPoint: CGPoint) -> Bool {
        // based on the distance between initPoint, currentPoint, it determines whether the view controller should dismiss or not.
        
        let yDelta = abs(currentPoint.y - initPoint.y)
        return (yDelta / referenceValue > 0.7) ? true : false
    }
    
    
    func updateButtons() {
        
        // set the appropriate toolbarItems based on the mediaType of the asset
        if asset.mediaType == .video {
            
            toolbarItems = [favoriteButton, space, playButton, space, trashButton]
            navigationController?.isToolbarHidden = false
            
        } else {
            // Live Photos have their own playback UI, so present them like regular photos, just like Photos app.
            toolbarItems = [favoriteButton, space, trashButton]
            navigationController?.isToolbarHidden = false
        }
        
        // enable favorite button if the asset can toggle favorite configuration
        favoriteButton.isEnabled = asset.canPerform(.properties)
        favoriteButton.image = asset.isFavorite ? UIImage(named:"heartSelected.png") : UIImage(named:"heartNormal.png")

        // enable the trash button if the asset can be deleted
        trashButton.isEnabled = asset.canPerform(.delete)
    }
    
    func updateImage() {

        if asset.mediaSubtypes.contains(.photoLive) {
            updateLivePhoto()
        } else {
            updateStaticImage()
        }
    }

    func updateLivePhoto() {
        // Prepare the options to pass when fetching the live photo.
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        // Request the live photo for the asset from the default PHImageManager.
        PHImageManager.default().requestLivePhoto(for: asset, targetSize: targetSize(), contentMode: .aspectFit, options: options, resultHandler: { livePhoto, info in
            // Hide the progress view now the request has completed.
            self.progressView.isHidden = true
            
            // If successful, show the live photo view and display the live photo.
            guard let livePhoto = livePhoto else { return }

            self.livePhotoView.livePhoto = livePhoto
            self.livePhotoView.contentMode = .scaleAspectFit
            
            guard let info = info else { return }
            if let degraded = info[PHImageResultIsDegradedKey as NSString] as? Bool, degraded == true && self.isPlayingHint {
                
                // Playback a short section of the live photo; similar to the Photos share sheet.
                self.isPlayingHint = true
                self.livePhotoView.startPlayback(with: .hint)
            }
            
        })
    }
    
    func updateStaticImage() {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                self.progressView.progress = Float(progress)
            }
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize(), contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            // Hide the progress view now the request has completed.
            self.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let image = image else { return }
            self.imageView.image = image
        })
    }
    
    
    // MARK: Helper methods
    func updateViewHiddenSetting() {
        // Fix the views' isHidden setting that could be adjusted for some reasons that includes view controller transition animation.
        
        if asset.mediaSubtypes.contains(.photoLive) {
            self.livePhotoView.isHidden = false
            self.imageView.isHidden = true
        } else {
            self.livePhotoView.isHidden = true
            self.imageView.isHidden = false
        }
    }
    
    
    func hideAllViews() {
        // Hiding these views all together is necessary for effectiveness of the view controller transition animation.
        self.livePhotoView.isHidden = true
        self.imageView.isHidden = true
    }
    
    func setSnapshotImgView() {
        // Make a snapshot of the image currently displaying in the view. This snapshot image view is going to be used as a copycat for view controller dismissal animation.
        
        snapShotImgView = UIImageView()
        snapShotImgView.contentMode = .scaleAspectFill
        snapShotImgView.clipsToBounds = true
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize(), contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            
            guard let image = image else { return }
            self.snapShotImgView.image = image
            self.snapShotImgView.frame = self.view.frame
        })

        snapShotImgView.frame = AVMakeRect(aspectRatio: snapShotImgView.image!.size, insideRect: self.view.bounds)
    }
    
    
    func snapshotBgAlpha(initPoint: CGPoint, referenceValue: CGFloat, currentPoint: CGPoint) -> CGFloat {
        // MomentsViewController view's snapshot is transparent in the beginning. In reference to pan gesture translation value, the transparency is going to be thinner.
        
        let yDelta = abs(currentPoint.y - initPoint.y)
        var alpha: CGFloat
        
        if (yDelta / referenceValue < 0.7) {
            alpha = yDelta / referenceValue
        }
        else {
            alpha = 0.7
        }
        
        return alpha
    }

    func targetSize() -> CGSize {
        // image size to request to the library
        
        let scale = UIScreen.main.scale
        return CGSize(width: self.imageView.bounds.width * scale,
                      height: self.imageView.bounds.height * scale)
    }
    
    
    // MARK: Button Actions
    @IBAction func play(_ sender: AnyObject) {
        if playerLayer != nil {
            // An AVPlayerLayer has already been created for this asset; just play it.
            playerLayer.player!.play()
        } else {
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .automatic
            options.progressHandler = { progress, _, _, _ in
                // Handler might not be called on the main queue, so re-dispatch for UI work.
                DispatchQueue.main.sync {
                    self.progressView.progress = Float(progress)
                }
            }
            
            // Request an AVPlayerItem for the displayed PHAsset and set up a layer for playing it.
            PHImageManager.default().requestPlayerItem(forVideo: asset, options: options, resultHandler: { playerItem, info in
                DispatchQueue.main.sync {
                    guard self.playerLayer == nil else { return }
                    
                    // Create an AVPlayer and AVPlayerLayer with the AVPlayerItem.
                    let player = AVPlayer(playerItem: playerItem)
                    let playerLayer = AVPlayerLayer(player: player)
                    
                    // Configure the AVPlayerLayer and add it to the view.
                    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
                    playerLayer.frame = self.view.layer.bounds
                    self.view.layer.addSublayer(playerLayer)
                    
                    player.play()
                    
                    // Refer to the player layer so we can remove it later.
                    self.playerLayer = playerLayer
                }
            })
        }
        
    }
    
    @IBAction func removeAsset(_ sender: AnyObject) {
        // delete the asset from the library
        
        let completion = { (success: Bool, error: Error?) -> () in
            if success {
                PHPhotoLibrary.shared().unregisterChangeObserver(self)
                DispatchQueue.main.sync {
                    
                    // The change observer implemented in MomentsViewController is going to reload its view with the asset removal reflected. The 'isHidden' setting that has been triggered when the view controller transition animation occured must be undone.
                    self.delegate?.undoCellSelection()
                    _ = self.navigationController!.popViewController(animated: true)
                }
            } else {
                print("can't remove asset: \(error)")
            }
        }
        
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([self.asset] as NSArray)
        }, completionHandler: completion)
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        // submit the asset metadata (which is 'favorite') changes to the library
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.asset)
            
            request.isFavorite = !self.asset.isFavorite
        }, completionHandler: { success, error in
            if success {

            } else {
                print("can't set favorite: \(error)")
            }
        })
    }
}

extension DetailViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Call might come on any background queue. Re-dispatch to the main queue to handle it.
        
        DispatchQueue.main.sync {
            // Check if there are changes to the asset we're displaying.
            guard let details = changeInstance.changeDetails(for: asset) else { return }
            
            // Get the updated asset.
            asset = details.objectAfterChanges as! PHAsset
            
            updateButtons()
            
            // If the asset's content changed, update the image and stop any video playback.
            if details.assetContentChanged {
                updateImage()
                
                playerLayer?.removeFromSuperlayer()
                playerLayer = nil
            }
            
            
        }

    }
}

extension DetailViewController: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
}
