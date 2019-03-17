//
//  ViewController.swift
//  ReplaceScrollViewTest
//
//  Created by SeoGiwon on 04/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBAction func btnTapped(_ sender: UIBarButtonItem) {
        
        populateSplitViewList()
        collectionView.reloadData()
        collectionView.delegate = self
        

    }
    
    
    @IBAction func valueChanged(_ sender: UISlider) {
        
        heightConstraint.constant = CGFloat(128 + sender.value)        
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var layoutEditingViewList = [LayoutEditingView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    
    private func populateSplitViewList() {
        
        let layoutEditingViewAlpha = LayoutEditingView_Type1(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        let layoutEditingViewBeta = LayoutEditingView_Type2(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        let layoutEditingViewGamma = LayoutEditingView_Type3(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.size.height - 64) * (2.0 / 3.0)))
        
        
        layoutEditingViewAlpha.createSnapShot()
        layoutEditingViewBeta.createSnapShot()
        layoutEditingViewGamma.createSnapShot()

        
        layoutEditingViewList.removeAll()
        layoutEditingViewList.append(layoutEditingViewAlpha)
        layoutEditingViewList.append(layoutEditingViewBeta)
        layoutEditingViewList.append(layoutEditingViewGamma)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return layoutEditingViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let splitView = layoutEditingViewList[indexPath.row]
        let snapShotView = splitView.snapShot
        snapShotView!.frame = cell.bounds
        
        cell.contentView.addSubview(snapShotView!)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let editViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LayoutEditViewController") as? LayoutEditViewController {
            
            editViewController.photoSplitView = layoutEditingViewList[indexPath.row]
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: heightConstraint.constant - 28, height: heightConstraint.constant - 28)
        return size
    }
}


