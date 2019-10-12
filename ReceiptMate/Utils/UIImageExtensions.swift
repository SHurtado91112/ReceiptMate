//
//  UIImageExtensions.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func image(for urlStr: String, placeHolder: UIImage? = nil, completion: @escaping (UIImage?, NSError?)->Void) {
        
        if let cachedImage = Cache.IMAGE_CACHE.object(forKey: NSString(string: urlStr)) {
            completion(cachedImage, nil)
            return
        }
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if let error = error {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        completion(placeHolder, error as NSError)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            Cache.IMAGE_CACHE.setObject(downloadedImage, forKey: NSString(string: urlStr))
                            completion(downloadedImage, nil)
                        }
                    }
                }
            }).resume()
        }
    }
    
    func jpegReduced(to megabytes: Int64) -> Data {
        var quality: CGFloat = 1.0
        var data: Data?
        
        repeat {
            data = self.jpegData(compressionQuality: quality)
            quality = quality - 0.1
        }
        while(Int64(data?.count ?? -1) > megabytes)
        
        return data ?? Data()
    }
}
