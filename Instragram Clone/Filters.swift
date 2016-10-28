//
//  Filters.swift
//  Instragram Clone
//
//  Created by John Shaff on 10/25/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    // Static means that it only applies to this class. So by instantiating a Filter() class one and storing it within itself in a static variable that's only available within itself, then we have to access everything within the class through the Share static constant. 
    
    static let shared = Filters()
    static var originalImage = UIImage()
    let context: CIContext
    
    //The private initializer doesn't allow initialization again
    private init() {
        
        let options = [kCIContextWorkingColorSpace: NSNull()]
        let eaglContext = EAGLContext(api: .openGLES2)
        self.context = CIContext(eaglContext: eaglContext!, options: options)
        
    }
    
    //Takes in the image from the specific filter
    private func filter(name: String, image: UIImage, completion: @escaping FilterCompletion) {
        
        OperationQueue().addOperation {
            guard let filter = CIFilter(name: name) else { fatalError("Check filter name spelling") }
        
            
        
        let ciImage = CIImage(image: image)
        
        //Setting the value a
        filter.setValue(ciImage, forKey: kCIInputImageKey)
            print(kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { fatalError("Error retrieving output image from filter.") }
        
        //Draw the image on the context
        guard let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) else { fatalError("Error creating CGImage on GPU Context.") }
        
        //Spit out the UIImage
        OperationQueue.main.addOperation {
            completion(UIImage(cgImage: cgImage))
        }
        }
    }
    
    func original(image: UIImage, completion: @escaping FilterCompletion) {
        completion(Filters.originalImage)
    }
    
    
    func vintage(image: UIImage, completion: @escaping FilterCompletion) {
    self.filter(name: "CIPhotoEffectTransfer", image: image, completion: completion)
    }
    
    func blackAndWhite(image: UIImage, completion: @escaping FilterCompletion) {
        self.filter(name: "CIPhotoEffectMono", image: image, completion: completion)
    }
    
    func chrome(image: UIImage, completion: @escaping FilterCompletion) {
        self.filter(name: "CIPhotoEffectChrome", image: image, completion: completion)
    }
    
    
    //HOMEWORK FILTERS
    func noir(image: UIImage, completion: @escaping FilterCompletion) {
        self.filter(name: "CIPhotoEffectNoir", image: image, completion: completion)
    }
    
    func thermal(image: UIImage, completion: @escaping FilterCompletion) {
        self.filter(name: "CIThermal", image: image, completion: completion)
    }
}


