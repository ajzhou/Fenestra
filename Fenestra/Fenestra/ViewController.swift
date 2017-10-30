//
//  ViewController.swift
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/11/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView = UIImageView()
    var image : CIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize image
        image = CIImage(image: UIImage.init(named: "skydive")!)
        
        // setup ImageView
        view.addSubview(imageView);
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        // setup Tap
        setupTap()
        
        // Display Original Image
        imageView.image = UIImage(ciImage: image!)
    }
    
    func setupTap() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        // code to test gaussianBlur() ----------------------------------------
//        image = gaussianBlur(inputImage: image!, sigma: 30)
//
//
//        // Display new image on imageView
//        imageView.image = UIImage(ciImage: image!)
        // code to test gaussianBlur() ----------------------------------------
        
        // code to test diffOfGaussian() ----------------------------------------
//        let imageLo = gaussianBlur(inputImage: image!, sigma: 1.0)
//        let imageHi = gaussianBlur(inputImage: image!, sigma: 30.0)
//        let output = diffOfGaussian(inputImageLo: imageLo, inputImageHi: imageHi)
//
//        imageView.image = UIImage.init(ciImage: output)
        // code to test diffOfGaussian() ----------------------------------------
        
        let output = detectExtrema(image: image!, sigma: 10.0)
        imageView.image = UIImage.init(ciImage: output)
        
        print("whats up")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


