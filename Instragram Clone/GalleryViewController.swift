//
//  GalleryViewController.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/26/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPosts = [Post](){
        didSet {
    
            collectionView.reloadData()
            
       }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = GalleryViewFlowLayout(columns: 3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        API.shared.getPosts { (posts) in
            if let posts = posts {
                self.allPosts = posts
            }
        }
    }
    
    @IBAction func userPinch(_ sender: UIPinchGestureRecognizer) {
        guard let layout = self.collectionView.collectionViewLayout as? GalleryViewFlowLayout else { return }
        
        switch sender.state {
        case .ended:
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            
            // handles an edge case
            if columns < 1 || columns > 10 {
                return
            }
            
            UICollectionView.animate(withDuration: 0.25, animations: {
                let newLayout = GalleryViewFlowLayout(columns: columns)
                self.collectionView.setCollectionViewLayout(newLayout, animated: true)
                })
        default:
            return
        }
    }
}


extension GalleryViewController: UICollectionViewDataSource {
    
    
    //deque the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //UICollectionViewCell is a subclass
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier(), for: indexPath) as! GalleryCell
        
        postCell.post = allPosts[indexPath.row]
        
        return postCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    
}
