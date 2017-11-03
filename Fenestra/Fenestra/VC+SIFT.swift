//
//  VC+SIFT.swift
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/29/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

import Foundation
import UIKit

// SIFT Detector functions
extension ViewController {
    // grayscale images
    func rgb2gray(inputImage: CIImage) -> CIImage {
        let grayscale = CIFilter(name: "rgb2gray")
        grayscale?.setValue(inputImage, forKey: kCIInputImageKey)
        return (grayscale?.outputImage)!
    }
    
    // downsample by factor of 2
    func downSampleBy2(inputImage: CIImage) -> CIImage {
        let halve = CIFilter(name: "halve")
        halve?.setValue(inputImage, forKey: kCIInputImageKey)
        return (halve?.outputImage)!
    }
    
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
    
    // Gaussian Blur
    func gaussianBlur(inputImage: CIImage, sigma: Double) -> CIImage {
        // Gaussian Convolution
        let gaussian1X = CIFilter(name: "gaussian1X")
        gaussian1X?.setValue(inputImage, forKey: kCIInputImageKey)
        gaussian1X?.setValue(sigma, forKey: "inputSigma")
        let output1X = gaussian1X?.outputImage
                
        let gaussian1Y = CIFilter(name: "gaussian1Y")
        gaussian1Y?.setValue(output1X, forKey: kCIInputImageKey)
        gaussian1Y?.setValue(sigma, forKey: "inputSigma")
        let convolvedImg = gaussian1Y?.outputImage

        return convolvedImg!
    }
    
    // Difference of Gaussian
    // inputImageHi has the higher sigma value 
    func diffOfGaussian(inputImageLo: CIImage, inputImageHi: CIImage) -> CIImage {
        let diff = CIFilter(name: "difference")
        diff?.setValue(inputImageLo, forKey: "inputImageLo")
        diff?.setValue(inputImageHi, forKey: "inputImageHi")
        guard let output = diff?.outputImage else {
            print("error with Difference of Gaussian Function")
            return inputImageLo
        }
        return output
    }
    
    // Detect local extrema in one octave
    func detectExtrema(inputImage: CIImage, sigma: Double)-> [CIImage]{
        var extrema = [CIImage]()
        
        let image = rgb2gray(inputImage: inputImage)
//        let image = inputImage
        let k = 1.41421356237 // sqrt(2)
        
        // Stack of blurred images
        let blurredImage1 = gaussianBlur(inputImage: image, sigma: sigma)
        let blurredImage2 = gaussianBlur(inputImage: image, sigma: sigma * k)
        let blurredImage3 = gaussianBlur(inputImage: image, sigma: sigma * k * k)
        let blurredImage4 = gaussianBlur(inputImage: image, sigma: sigma * k * k * k)
        let blurredImage5 = gaussianBlur(inputImage: image, sigma: sigma * k * k * k * k)
        
        // Stack of Difference of Gaussian images
        let diffGauss1 = diffOfGaussian(inputImageLo: blurredImage1, inputImageHi: blurredImage2)
        let diffGauss2 = diffOfGaussian(inputImageLo: blurredImage2, inputImageHi: blurredImage3)
        let diffGauss3 = diffOfGaussian(inputImageLo: blurredImage3, inputImageHi: blurredImage4)
        let diffGauss4 = diffOfGaussian(inputImageLo: blurredImage4, inputImageHi: blurredImage5)
        
        // Extrema extraction through comparison of 26(9+8+9) neighbors
        let comp26 = CIFilter(name: "extractExtrema")
        // First compare diffGauss1,2,3 | with diffGauss2 in the middle of stack
        comp26?.setValue(diffGauss2, forKey: "inputImage")
        comp26?.setValue(diffGauss1, forKey: "inputComparison1")
        comp26?.setValue(diffGauss3, forKey: "inputComparison2")
        comp26?.setValue(sigma * k, forKey: "inputSigma")
        let extrema1 = comp26?.outputImage
        extrema.append(extrema1!)
        
        // Next compare diffGauss2,3,4 | with diffGauss3 in the middle of stack
        comp26?.setValue(diffGauss3, forKey: "inputImage")
        comp26?.setValue(diffGauss2, forKey: "inputComparison1")
        comp26?.setValue(diffGauss4, forKey: "inputComparison2")
        comp26?.setValue(sigma * k * k * k, forKey: "inputSigma")
        let extrema2 = comp26?.outputImage
        extrema.append(extrema2!)
    
        return extrema
    }
    
    // Eliminate unstable keypoints
    func eliminateUnstableKeypoints(map: CIImage, src: CIImage, hiImg: CIImage, hiHiImg: CIImage, loImg: CIImage, loLoImg: CIImage) -> CIImage {
        let findOffset = CIFilter(name: "calculateOffset")
        findOffset?.setValue(map, forKey: "inputMap")
        findOffset?.setValue(src, forKey: "inputImage")
        findOffset?.setValue(hiImg, forKey: "inputHigherScaleImage")
        findOffset?.setValue(hiHiImg, forKey: "inputHigherHigherScaleImage")
        findOffset?.setValue(loImg, forKey: "inputLowerScaleImage")
        findOffset?.setValue(loLoImg, forKey: "inputLowerLowerScaleImage")
        
        return (findOffset?.outputImage)!
    }

}
