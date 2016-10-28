//
//  Post.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/25/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit
import CloudKit

enum PostError: Error {
    case writingImageToData
    case writingDataToDisk
    
}

class Post {
    
    let image: UIImage
    
    init(image: UIImage = UIImage()) {
        self.image = image
    }
}


extension Post {
    class func recordFor(post: Post) throws -> CKRecord? {
        let imageURL = URL.imageURL()
        
        guard let data = UIImageJPEGRepresentation(post.image, 1) else { throw PostError.writingDataToDisk }
        
        
        do {
            try data.write(to: imageURL)
            
            let asset = CKAsset(fileURL: imageURL)
            let record = CKRecord(recordType: String(describing: self))
            
            record.setObject(asset, forKey: "image")
            
            return record
            
        } catch {
            throw PostError.writingDataToDisk
        }
    }
}
