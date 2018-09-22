//
//  RoundedImageView.swift
//  BreakPoint
//
//  Created by DokeR on 21.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    let imageCache = NSCache<AnyObject, AnyObject>()

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        //self.image = UIImage(named: "defaultProfileImage")
    }
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
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
                self.image = downloadedImage
            }
        }.resume()
    }

}
