//
//  FiltersPreviewController.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/27/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

//IM ABOUT TO CREATE A DELEGATE YA'LL
//NAMED EXACT
protocol FiltersPreviewViewControllerDelegate: class {
    
    func filtersPreviewController(selected: UIImage)
}



class FiltersPreviewController: UIViewController {
    
    // Because we're assigning the delegate to this variable we need to set it as weak because the del
    
    weak var delegate: FiltersPreviewViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let filters = [Filters.shared.original, Filters.shared.blackAndWhite, Filters.shared.chrome, Filters.shared.vintage]
    
    var post = Post()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryViewFlowLayout(columns: 2)
    }

}

extension FiltersPreviewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension FiltersPreviewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier(), for: indexPath) as! GalleryCell
        
        let filter = self.filters[indexPath.row]
        
        
        // the Filter function from the Filters model file is being executed here, and then the closure automatically runs, which it always does. 
        
        filter(self.post.image) { (filteredImage) in
            filterCell.cellImage.image = filteredImage
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let filter = self.filters[indexPath.row]
        
        filter(self.post.image, { (filteredImage) in
            if let filteredImage = filteredImage {
                delegate.filtersPreviewController(selected: filteredImage)
            }
        })
    }

}
    

