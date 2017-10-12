//
//  File.swift
//  GiwonWebImage
//
//  Created by SeoGiwon on 25/05/2017.
//  Copyright © 2017 SeoGiwon. All rights reserved.
//

import UIKit

class GiwonWebImage {
    
    static let sharedInstance = GiwonWebImage()
    let appCache = NSCache<NSString, UIImage>()
    
    func image(from webUrlString:String, completion:@escaping (_ image: UIImage?) -> Void) {
        
        if let img = appCache.object(forKey: (webUrlString.keyFileString() ?? "") as NSString) {
            completion(img)
            return
        }

        if let img = imageFromLocalFile(with: (webUrlString.keyFileString() ?? "")) {
            completion(img)
            return
        } else {
            downloadImage(from: webUrlString, completion: completion)
        }
    }
    
    func save(image: UIImage, urlStr: String) -> Bool {
        
        if let keyFileString = urlStr.keyFileString(),
            GiwonWebImage.save(image: image, fileName: keyFileString) {
            return true
        } else {
            return false
        }
    }
    
    private func imageFromLocalFile(with fileName: String) -> UIImage? {
        
        if let img = GiwonWebImage.load(with: fileName) {
            appCache.setObject(img, forKey: fileName as NSString)
            return img
        } else {
            return nil
        }
    }
    
    private func downloadImage(from urlString: String, completion:@escaping (_ image: UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    
                    completion(nil)
                    return
            }
            
            
            if let keyFileString = urlString.keyFileString(),
                GiwonWebImage.save(image: image, fileName: keyFileString) {
            
                completion(self.imageFromLocalFile(with: keyFileString))
                
            } else {
                completion(image)
            }
            
        }
    }
    
    
}

// save, load files
extension GiwonWebImage {
    
    static fileprivate let storageDirectoryName = "ImageDirectory"
    
    static fileprivate func save(image: UIImage, fileName: String) -> Bool {
        
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
    
    static fileprivate func load(with fileName: String) -> UIImage? {
        
        let url = URL(fileURLWithPath: fullPath(with: fileName))
        
        guard let data = try? Data(contentsOf: url),
            let img = UIImage(data: data) else {
                return nil
        }
        
        return img
    }
    
    static fileprivate func fullPath(with fileName: String) -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsDirectoryPath = (documentsPath as NSString).appendingPathComponent(GiwonWebImage.storageDirectoryName)
        
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
    
    static func isJPG(from urlString: String) -> Bool {
        
        return urlString.lowercased().contains(".jpg") || urlString.lowercased().contains(".jpeg") ? true : false
    }
}

extension String {
    
    // create the key string out of the url's absolute string for accessing NSCache or local file
    func keyFileString() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}
