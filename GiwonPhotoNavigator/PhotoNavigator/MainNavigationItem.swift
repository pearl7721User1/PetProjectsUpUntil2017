//
//  ListItemView.swift
//  MiniatureScrollViewTest
//
//  Created by SeoGiwon on 10/06/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class MainNavigationItem: UIImageView {

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.contentMode = .scaleAspectFit
    }

}
