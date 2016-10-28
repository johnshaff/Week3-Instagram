//
//  API.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/24/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit
import CloudKit

typealias postCompletion = (Bool) -> ()
typealias GetPostsCompletion = ([Post]?)-> ()


class API {
    
    static let shared = API()
    
    let container: CKContainer
    let database: CKDatabase
    
    private init() {
        self.container = CKContainer.default()
        self.database = self.container.privateCloudDatabase
    }
    
    
    
    func save(post: Post, completion: @escaping postCompletion) {
        
        do {
            if let record = try Post.recordFor(post: post) {
                self.database.save(record, completionHandler: { (record, error) in
                    print(record, error)
                    if error == nil && record != nil {
                        print("Success saving\(record!)")
                        OperationQueue.main.addOperation {
                            completion(true)
                        }
                    }
                })
            }
        } catch {
            print(error)
            completion(false)
            
        }
    }
    
    
    func getPosts(completion: @escaping GetPostsCompletion) {
        let query = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
        
        self.database.perform(query, inZoneWith: nil) { (records, error) in
            if error == nil {
                if let records = records {
                    var posts = [Post]()
                    
                    //this is the same thing as if let records != nil
                    for record in records {
                        guard let asset = record["image"] as? CKAsset else { return }
                        let path = asset.fileURL.path
                        
                        guard let image = UIImage(contentsOfFile: path) else { return }
                        
                        posts.append(Post(image: image))
                    }
                    
                    OperationQueue.main.addOperation {
                        completion(posts)
                    }
                }
            } else {
                print(error)
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
}


