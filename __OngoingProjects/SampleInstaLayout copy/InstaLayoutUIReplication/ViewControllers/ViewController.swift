//
//  ViewController.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 04/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//


// Aug.11.2017
// 1 Demonstrating how to resize an image itself by creating a new bitmap
// 2 Setting contents for an UIScrollview using AutoLayout approach


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBAction func btnTapped(_ sender: UIBarButtonItem) {
        
        populateSplitViewList()
        collectionView.reloadData()
        
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var splitViewList = [SplitControllerView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    
    private func populateSplitViewList() {
        
        let splitControllerViewAlpha = SplitControllerView_Type1(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        let splitControllerViewBeta = SplitControllerView_Type2(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        let splitControllerViewGamma = SplitControllerView_Type3(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        
        splitControllerViewAlpha.createSnapShot()
        splitControllerViewBeta.createSnapShot()
        splitControllerViewGamma.createSnapShot()

        
        splitViewList.removeAll()
        splitViewList.append(splitControllerViewAlpha)
        splitViewList.append(splitControllerViewBeta)
        splitViewList.append(splitControllerViewGamma)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return splitViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let splitView = splitViewList[indexPath.row]
        let snapShotView = splitView.snapShot
        //let snapShotView = splitView.snapshotView(afterScreenUpdates: true)
        snapShotView!.frame = cell.bounds
        
        cell.contentView.addSubview(snapShotView!)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let editViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LayoutEditViewController") as? LayoutEditViewController {
            
            editViewController.photoSplitView = splitViewList[indexPath.row]
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
}

extension UIImage {
    
    func getContentAspectFillImgViewRect2(fromRect: CGRect) -> CGRect {
        
        let frameWHRate = fromRect.size.width / fromRect.size.height
        let imgWHRate = self.size.width / self.size.height
        
        let factor = frameWHRate > imgWHRate ?
            self.size.width / fromRect.size.width :
            self.size.height / fromRect.size.height
        
        let imgViewRect = CGRect(x: 0, y: 0, width: fromRect.width, height: self.size.height)
        let returnRect = CGRect(x: 0, y: 0, width: imgViewRect.width * factor, height: imgViewRect.height * factor)
        
        return returnRect
    }
    
    func getContentAspectFillImgViewRect(fromRect: CGRect) -> CGRect {
        let frameWHRate = fromRect.size.width / fromRect.size.height
        let imgWHRate = self.size.width / self.size.height
        
        let factor = frameWHRate > imgWHRate ?
            self.size.width / fromRect.size.width :
            self.size.height / fromRect.size.height
        
        let returnRect = CGRect(x: 0, y: 0, width: self.size.width / factor, height: self.size.height / factor)
        
        return returnRect
    }
    
    func getNewImage(forRect rect: CGRect) -> UIImage? {
        
        guard let cgImage = self.cgImage,
            let colorSpace = cgImage.colorSpace else { return nil }
        
        let newWidth =  floorf(Float(rect.width))
        
        let newBitmapContext = CGContext.init(data: nil, width: Int(newWidth), height: Int(rect.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: Int(CGFloat(cgImage.bytesPerRow) / CGFloat(cgImage.width) * CGFloat(newWidth)), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        
        newBitmapContext?.draw(cgImage, in: rect)
        let imgRef = newBitmapContext?.makeImage()
        
        if let imgRef = imgRef {
            return UIImage(cgImage: imgRef)
        } else {
            return nil
        }
    }
}

/*
- (CGSize)getContentAspectFillSizeWithOuterRect:(CGRect)frame withImgSize:(CGSize)imgSize
{
    float frameWHRate = frame.size.width / frame.size.height;
    float imgWHRate = imgSize.width / imgSize.height;
    
    float conversionFactor;
    CGSize returnSize;
    
    if (frameWHRate > imgWHRate) {
        
        conversionFactor = imgSize.width / frame.size.width;
        returnSize = CGSizeMake(imgSize.width / conversionFactor, imgSize.height / conversionFactor);
        
    }
    else {
        
        conversionFactor = imgSize.height / frame.size.height;
        returnSize = CGSizeMake(imgSize.width / conversionFactor, imgSize.height / conversionFactor);
    }
    
    return returnSize;
}
 */
