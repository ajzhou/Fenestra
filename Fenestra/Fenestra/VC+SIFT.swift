//
//  VC+SIFT.swift
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/29/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // Filter that gaussian blurs then downsample by 2
    // radius is the half-width of filter - default should be 3 * sigma 
    func applyGaussianFilter(inputImage: CIImage, sigma: Int) -> CGImage {
        let context = CIContext()
        
        // Gaussian Convolution
        let gaussian1X = CIFilter(name: "gaussian1X")
        gaussian1X?.setValue(inputImage, forKey: kCIInputImageKey)
        gaussian1X?.setValue(sigma, forKey: "inputSigma")
        let output1X = gaussian1X?.outputImage
        
        let gaussian1Y = CIFilter(name: "gaussian1Y")
        gaussian1Y?.setValue(output1X, forKey: kCIInputImageKey)
        gaussian1Y?.setValue(sigma, forKey: "inputSigma")
        let convolvedImg = gaussian1Y?.outputImage
        
        // Downsample to N/2
        let halve = CIFilter(name: "halve")
        halve?.setValue(convolvedImg, forKey: kCIInputImageKey)
        let output = halve?.outputImage
        
        return context.createCGImage(output!, from: (output!.extent))!
    }
}
