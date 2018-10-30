//
//  DownloadImageHelper.swift
//  BreakPoint
//
//  Created by DokeR on 27.10.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class DownloadImageHelper {
    
    static let instance = DownloadImageHelper()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func loadImageUsingCacheWithUrlString(_ urlString: String, handler: @escaping (_ image: UIImage) ->() ) {
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            handler(cachedImage)
            return
        }
        
        //download and cache image
        guard let url = URL(string: urlString) else {
            print("errror")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "!!!error downloading Image!!")
                return
            }
            
            DispatchQueue.main.async {
                guard let downloadedImage = UIImage(data: data!) else {return}
                self.imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                handler(downloadedImage)
            }
            }.resume()
    }
    
}
