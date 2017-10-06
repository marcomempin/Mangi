//
//  UIImageView+ImageFromServerURL.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import Foundation
import UIKit

// http://stackoverflow.com/a/37019507/737370
extension UIImageView {
    public func imageFromServerURL(urlString: String, completion: @escaping () -> Void) {
        
        var newURLString = ""
        if urlString.isEmpty {
            newURLString = "http://via.placeholder.com/500x500"
            
        } else {
            let baseURL = "https://image.tmdb.org/t/p/"
            let fileSize = "w500"
            newURLString = baseURL.appending(fileSize).appending(urlString)
        }
        
        #if DEBUG
            print(newURLString)
        #endif
        
        URLSession.shared.dataTask(with: NSURL(string: newURLString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                completion()
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                completion()
            })
            
        }).resume()
    }
}


