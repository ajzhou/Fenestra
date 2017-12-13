//
//  ViewController.swift
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/11/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView1 = UIImageView()
    var imageView2 = UIImageView()
    var imageView3 = UIImageView()
    var imageView4 = UIImageView()
    var imageView5 = UIImageView()
    var imageView6 = UIImageView()
    var image : CIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize image
        image = CIImage(image: UIImage(named: "gradient_bl_tr")!)
//        image = rgb2gray(inputImage: image!)
        
        // setup ImageView
        let container1 = UIStackView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
        container1.axis = .horizontal
        container1.addArrangedSubview(imageView1)
        container1.addArrangedSubview(imageView2)
        container1.distribution = .fillEqually
        let container2 = UIStackView.init(frame: CGRect(x: 0 , y: UIScreen.main.bounds.height / 3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
        container2.axis = .horizontal
        container2.addArrangedSubview(imageView3)
        container2.addArrangedSubview(imageView4)
        container2.distribution = .fillEqually
        let container3 = UIStackView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
        container3.axis = .horizontal
        container3.addArrangedSubview(imageView5)
        container3.addArrangedSubview(imageView6)
        container3.distribution = .fillEqually
        view.addSubview(container1)
        view.addSubview(container2)
        view.addSubview(container3)

        imageView1.contentMode = .scaleAspectFit
        imageView2.contentMode = .scaleAspectFit
        imageView3.contentMode = .scaleAspectFit
        imageView4.contentMode = .scaleAspectFit
        imageView5.contentMode = .scaleAspectFit
        imageView6.contentMode = .scaleAspectFit
        
        // setup Tap
        setupTap()
        
        // Display Original Image
        imageView1.image = UIImage(ciImage: image!)
    
    }
    
    func setupTap() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
//        let im1 = UIImage(named: "gradient_horizontal")
//        let im2 = UIImage(named: "gradient_bl_tr")
//        let im3 = UIImage(named: "gradient_br_tl")
//        let im4 = UIImage(named: "gradient_tr_bl")
//
//        let gr1 = rgb2gray(inputImage: CIImage(image: im1!)!)
//        let gr2 = rgb2gray(inputImage: CIImage(image: im2!)!)
//        let gr3 = rgb2gray(inputImage: CIImage(image: im3!)!)
//        let gr4 = rgb2gray(inputImage: CIImage(image: im4!)!)
//
        let context = CIContext()
//        let mn1 = findMagAndOri(image: gr1)
//        let mn2 = findMagAndOri(image: gr2)
//        let mn3 = findMagAndOri(image: gr3)
//        let mn4 = findMagAndOri(image: gr4)
//
//        saveAsPNG(image: mn1, context: context)
//        saveAsPNG(image: mn2, context: context)
//        saveAsPNG(image: mn3, context: context)
//        saveAsPNG(image: mn4, context: context)
//
//        let kp = CIImage(image: UIImage(named: "kp_100_13")!)
//        let peak = findPeakOrientation(inputKP: kp!, inputMO: mn2, inputSigma: 2.0)
//        let pr = getKeypointLocationsFromImage(fromImage: convertCIImagetoCGImage(image: peak, context: context))
//        print(pr)
//        let cp = getRGBAs(fromImage: convertCIImagetoCGImage(image: mn2, context: context), x: 8, y: 12, count: 13)
//        print(cp)
//        let test = testKernel(image: image!)
//        let cp = getRGBAs(fromImage: convertCIImagetoCGImage(image: test, context: context), x: 0, y: 0, count: 50)
//        print(cp)
        
        // -----------------
        let gray = rgb2gray(inputImage: image!)

        let trick = CIImage(image: UIImage(named: "pixels100")!)
        let kp = detectSIFT(inputImage: trick!, sigma: 1.0, r: 10.0, numberOctave: 1)
        let pr = getKeypointLocationsFromImage(fromImage: convertCIImagetoCGImage(image: kp[1], context: context)) // 36 keypoints

        let locImg = drawLocationImage(locations: pr)

        print(pr)

        let mn = findMagAndOri(image: gray)
        saveAsPNG(image: mn, context: context)
        let peak = findPeakOrientation(inputKP: kp[1], inputMO: mn, inputSigma: 1.0)
        saveAsPNG(image: peak, context: context)
//        let pr2 = getKeypointLocationsFromImage(fromImage: convertCIImagetoCGImage(image: peak, context: context))
//        print(pr2.count)

        let output = runSIFTDescriptor(inputKPLocations: locImg, inputPeak: peak, inputMagOri: mn, length: Double(pr.count), sigma: 1.0)
        print(pr.count)
        print(output.extent)

//        saveAsPNG(image: output, context: context)
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


