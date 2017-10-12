//
//  File.swift
//  WorldCupSample
//
//  Created by SeoGiwon on 4/26/17.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class PersistenceManager {
    
    class func save(image: UIImage, fileName: String) -> Bool {
        
        if let data = isJPG(from: fileName) ? UIImageJPEGRepresentation(image, 1.0) : UIImagePNGRepresentation(image) {
            
            let url = URL(fileURLWithPath: fullPath(with: fileName))
            
            do {
                try data.write(to: url)
            }
            catch let error{
                print(error.localizedDescription)
                return false
            }
            
            return true
            
        } else {
            return false
        }
    }
    /*
    class func save(image: UIImage, fileName: String) -> Bool {
        
        var fileName = fileName
        guard let alpha = image.cgImage?.alphaInfo else {
            return false
        }
        
        let isJPG = [CGImageAlphaInfo.none, CGImageAlphaInfo.noneSkipLast].contains(alpha)//[CGImageAlphaInfo.none, CGImageAlphaInfo.noneSkipLast, CGImageAlphaInfo.noneSkipFirst].contains(alpha)
        
        isJPG ? fileName.append(".jpg") : fileName.append(".png")
        
        
        if let data = isJPG ? UIImageJPEGRepresentation(image, 1.0) : UIImagePNGRepresentation(image) {
            
            let url = URL(fileURLWithPath: fullPath(with: fileName))
            
            do {
                try data.write(to: url)
            }
            catch let error{
                print(error.localizedDescription)
                return false
            }
            
            return true
            
        } else {
            return false
        }
        
        
    }
    */
    
    class func load(with fileName: String) -> UIImage? {
        
        let url = URL(fileURLWithPath: fullPath(with: fileName))
 
        guard let data = try? Data(contentsOf: url),
            let img = UIImage(data: data) else {
                return nil
        }
        
        return img
    }
    
    
    class func fullPath(with fileName: String) -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsDirectoryPath = (documentsPath as NSString).appendingPathComponent("ImageDirectory")
        
        // if directory doesn't exist, create one
        let fileManager = FileManager.default
        
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: documentsDirectoryPath, isDirectory:&isDir), isDir.boolValue == true {
            
        } else {
            do {
                try fileManager.createDirectory(atPath: documentsDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("directory wasn't created")
            }
        }
        
        let fullPath = (documentsDirectoryPath as NSString).appendingPathComponent(fileName)
        
        print(fullPath)
        
        return fullPath
    }
    
    class func isJPG(from urlString: String) -> Bool {
        
        return urlString.lowercased().contains(".jpg") || urlString.lowercased().contains(".jpeg") ? true : false
    }
}
