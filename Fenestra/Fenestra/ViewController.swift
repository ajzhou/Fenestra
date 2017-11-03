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
//    var imageView2 = UIImageView()
//    var imageView3 = UIImageView()
//    var imageView4 = UIImageView()
    var image : CIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize image
        image = CIImage(image: UIImage.init(named: "skydive")!)
//        image = rgb2gray(inputImage: image!)
        
        // setup ImageView
        view.addSubview(imageView);
//        view.addSubview(imageView2);
//        view.addSubview(imageView3);
//        view.addSubview(imageView4);
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
        // code to test rgb2gray() ------------------------------------------------------------------------
//                let output = rgb2gray(inputImage: image!)
//                imageView.image = UIImage.init(ciImage: output)
        // ------------------------------------------------------------------------------------------------
        
        // code to test gaussianBlur() --------------------------------------------------------------------
        image = gaussianBlur(inputImage: image!, sigma: 30)
//
//
//        // Display new image on imageView
//        imageView.image = UIImage(ciImage: image!)
        // ------------------------------------------------------------------------------------------------
        
        // code to test diffOfGaussian() ------------------------------------------------------------------
//        let imageLo = gaussianBlur(inputImage: rgb2gray(inputImage: image!), sigma: 1.0)
//        let imageHi = gaussianBlur(inputImage: rgb2gray(inputImage: image!), sigma: 1.4)
//        let output = diffOfGaussian(inputImageLo: imageLo, inputImageHi: imageHi)
//
//        imageView.image = UIImage.init(ciImage: output)
        // ------------------------------------------------------------------------------------------------
        
        // code to test extractExtrema() ------------------------------------------------------------------
//        image = downSampleBy2(inputImage: image!)
//        image = downSampleBy2(inputImage: image!)
        let sigma = 1.6
//        let extrema = detectExtrema(inputImage: image!, sigma: sigma)
//        imageView.image = UIImage.init(ciImage: extrema[0])
        // ------------------------------------------------------------------------------------------------
        
        let k = 1.41421356237 // sqrt(2)
        
        // Stack of blurred images
//        let blurredImage1 = gaussianBlur(inputImage: image!, sigma: sigma)
//        let blurredImage2 = gaussianBlur(inputImage: image!, sigma: sigma * k)
//        let blurredImage3 = gaussianBlur(inputImage: image!, sigma: sigma * k * k)
//        let blurredImage4 = gaussianBlur(inputImage: image!, sigma: sigma * k * k * k)
//        let blurredImage5 = gaussianBlur(inputImage: image!, sigma: sigma * k * k * k * k)
//
//        let output = eliminateUnstableKeypoints(map: extrema[1], src: blurredImage3, hiImg: blurredImage4, hiHiImg: blurredImage5, loImg: blurredImage2, loLoImg: blurredImage1)
        
        imageView.image = UIImage.init(ciImage: image!)

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


