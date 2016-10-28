//
//  Extensions.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/25/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func resize(image: UIImage, size: CGSize) -> UIImage? {
        
        //this draws a context based on size which is a struct that has a height and width
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        image.draw(in: rect)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //this ends the method because it can only be running once.
        UIGraphicsEndImageContext()
        
        return resizedImage
        
    }
}

extension URL {
    
    //static func instead of class func because URL is not a class it's a struct
    static func imageURL() -> URL {
        
        //because we have a sandbox, and within that sandbox there is a file structure. That's what filemanager is managing, and this is the one overarcing one that manages our app.
        
        //we're getting an image path and then give it to cloudkit
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Error getting documents directories.") }
        return documentsDirectory.appendingPathComponent("image")
    }
}
