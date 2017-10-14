//
//  ListItemView.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 10/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class ThumbnailNavigationItem: UIView {

    static let itemSize = CGSize(width: 25, height: 50)
    static let wSpacing: CGFloat = 3
    static let hSpacing: CGFloat = 5
    static let widthConstraintIdentifier = "ListItemViewImportantConstraint"
    lazy var expandedItemWidth: CGFloat = {
    
        let imgAspect = self.image.size.width / self.image.size.height
        return imgAspect * ThumbnailNavigationItem.itemSize.height - ThumbnailNavigationItem.hSpacing
    }()
    
    var leftConstraintOffset: CGFloat {
        return (expandedItemWidth - shrinkedItemWidth) / 2.0
    }
    
    let shrinkedItemWidth:CGFloat = 22.0
    var image: UIImage!
    
    
    convenience init(with image: UIImage) {
        
        self.init(frame: CGRect(x: 0, y: 0, width: ThumbnailNavigationItem.itemSize.width - ThumbnailNavigationItem.wSpacing, height: ThumbnailNavigationItem.itemSize.height - ThumbnailNavigationItem.hSpacing))
        
        self.layer.contents = image.cgImage
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        for constraint in self.constraints {
            
            if let identifier = constraint.identifier {
                if identifier == ThumbnailNavigationItem.widthConstraintIdentifier {
                    constraint.constant = expandedItemWidth
                    
                }
            }
        }
    }
    
    func shrink() {
        
        for constraint in self.constraints {
            
            if let identifier = constraint.identifier {
                if identifier == ThumbnailNavigationItem.widthConstraintIdentifier {
                    constraint.constant = shrinkedItemWidth
                }
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
