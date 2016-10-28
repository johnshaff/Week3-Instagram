//
//  HomeViewController.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/24/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController {

    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func postImagePressed(_ sender: AnyObject) {
        if let image = imageView.image {
            let newPost = Post(image: image)
            API.shared.save(post: newPost, completion: {(success) in
                if success {
                    print("New post was saved to CloudKit.")
                    
                    let selector = #selector(HomeViewController.image(_:didFinishSaving:context:))
                    
                    UIImageWriteToSavedPhotosAlbum(image, self, selector, nil)
                }
            })
        }
    }
    
    
    @IBAction func imageLongPressed(_ sender: UILongPressGestureRecognizer) {
        //nothing will happen if you long press and you're not logged into Twitter
        guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
        
        composeController.add(imageView.image)
        self.present(composeController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == FiltersPreviewController.identifier {
            if let filterController = segue.destination as? FiltersPreviewController {
                filterController.post = Post(image: self.imageView.image!)
                filterController.delegate = self 
            }
        }
    }
    
    
    @IBAction func filterButtonPressed(_ sender: AnyObject) {
        
        guard self.imageView.image != nil else { return }
        
        //This segue will only happen if we pass the guard
        self.performSegue(withIdentifier: FiltersPreviewController.identifier, sender: nil)
        
        
        
//        let actionSheet = UIAlertController(title: "Filters", message: "Please pick a Filter:", preferredStyle: .actionSheet)
//        
//        let bwAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
//            Filters.shared.blackAndWhite(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//
//        let vintageAction = UIAlertAction(title: "Bring Sexy Back", style: .default) { (action) in
//            Filters.shared.vintage(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let noirAction = UIAlertAction(title: "All the Black & White", style: .default) { (action) in
//            Filters.shared.noir(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let chromeAction = UIAlertAction(title: "Draw me like your French Girls Jack", style: .default) { (action) in
//            Filters.shared.chrome(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let thermalAction = UIAlertAction(title: "Predator Mode", style: .default) { (action) in
//            Filters.shared.thermal(image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { (action) in
//            self.imageView.image = Filters.originalImage
//        }
//        
//        
//        actionSheet.addAction(bwAction)
//        actionSheet.addAction(vintageAction)
//        actionSheet.addAction(noirAction)
//        actionSheet.addAction(chromeAction)
//        actionSheet.addAction(thermalAction)
//        actionSheet.addAction(resetAction)
//        
//        
//        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func image(_ image: UIImage, didFinishSaving error: NSError?, context: UnsafeRawPointer){
        if error == nil {
            let alert = UIAlertController(title: "Saved", message: "Your image was saved to your photos", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //executed whenever the view is loaded into memory, this method is also called only once during the life of the view controller object.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //This animates the contraints to my buttons
        presentImagePicker(sourceType: .photoLibrary)
        postButtonBottomConstraint.constant = 100
        filterButtonTopConstraint.constant = 100
        self.view.layoutIfNeeded()
        
        postButtonBottomConstraint.constant = 8
        filterButtonTopConstraint.constant = 8
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        
        for name in CIFilter.filterNames(inCategories: nil){
            print(name)
        }
        
    }
    
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func presentActionSheet() {
        
        let actionSheet = UIAlertController(title: "Source", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .destructive) {
            (action) in
            print("about to present the imagePickerController")
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraAction.isEnabled = false
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func imageTapped(_ sender: AnyObject) {
        presentActionSheet()
    }
    
}


extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        }
        
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("the user selected an image and now the UIImagePickerController will be dismissed")
        
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = originalImage
            Filters.originalImage = originalImage
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension HomeViewController: FiltersPreviewViewControllerDelegate {
    func filtersPreviewController(selected: UIImage) {
        self.dismiss(animated: true, completion: nil)
        self.imageView.image = selected
    }
}
    
