//
//  File.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 07/09/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension String {
    func image() -> UIImage? {
        
        guard let url = URL(string: self),
            let data = try? Data.init(contentsOf: url),
            let image = UIImage(data: data) else {
            
            return nil
        }
        
        return image
    }
    
    func imageNSData() -> NSData? {
        guard let url = URL(string: self),
            let data = try? Data.init(contentsOf: url) else {
            
            return nil
        }
        
        return NSData(data: data)
    }
}
