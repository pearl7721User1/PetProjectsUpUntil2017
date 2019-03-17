//
//  MyToolbar.swift
//  PhotoNavigator
//
//  Created by SeoGiwon on 16/12/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

/// MyToolbar is defined to customize the hit testing stuff
class MyToolbar: UIToolbar {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        for subview in self.subviews {
            
            if let view = subview.hitTest(_:point, with:event) {
                return view
            }
        }
        
        return nil
    }
}
