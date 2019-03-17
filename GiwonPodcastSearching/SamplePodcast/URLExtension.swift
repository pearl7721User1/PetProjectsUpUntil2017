//
//  File.swift
//  SamplePodcast
//
//  Created by SeoGiwon on 17/08/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

extension URL {
    func removeArgument() -> URL? {
        
        if let scheme = self.scheme,
            let host = self.host {
            
            var newURLStr = scheme + "://" + host
            
            
            let pathComponents = self.pathComponents
            
            for component in pathComponents {
                
                newURLStr = newURLStr + (component == "/" ? component : component + "/")
            }
            
            return URL(string: newURLStr)
        }
        else {
            return nil
        }
    }
}
