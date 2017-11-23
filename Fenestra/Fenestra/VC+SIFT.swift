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
    func detectKeypoints(inputImage: CIImage, sigma: Double, r: Double)-> [CIImage]{
        var extrema = [CIImage]()
        let image = rgb2gray(inputImage: inputImage)
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
        let extrema1 = (comp26?.outputImage)!
        extrema.append(extrema1)
        
        // Next compare diffGauss2,3,4 | with diffGauss3 in the middle of stack
        comp26?.setValue(diffGauss3, forKey: "inputImage")
        comp26?.setValue(diffGauss2, forKey: "inputComparison1")
        comp26?.setValue(diffGauss4, forKey: "inputComparison2")
        let extrema2 = (comp26?.outputImage)!
        extrema.append(extrema2)
        
        // reject edges
        let edger = CIFilter(name: "edgeRejection")
        edger?.setValue(extrema1, forKey: "inputMap")
        edger?.setValue(diffGauss2, forKey: "inputImage")
        edger?.setValue(r, forKey: "inputThreshold")
        let kp1 = (edger?.outputImage)!
        
        edger?.setValue(extrema2, forKey: "inputMap")
        edger?.setValue(diffGauss3, forKey: "inputImage")
        edger?.setValue(r, forKey: "inputThreshold") 
        let kp2 = (edger?.outputImage)!
        
        // ImageView display
        let context = CIContext()
        imageView2.image = UIImage(cgImage: convertCIImagetoCGImage(image: diffGauss3, context: context))
        imageView3.image = UIImage(cgImage: convertCIImagetoCGImage(image: diffGauss4, context: context))
        imageView4.image = UIImage(cgImage: convertCIImagetoCGImage(image: kp1, context: context))
        imageView5.image = UIImage(cgImage: convertCIImagetoCGImage(image: kp2, context: context))
//        imageView6.image = UIImage(cgImage: cg(image: diffGauss4, context: context))
        
        
        // save images to photos
//        UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cg(image: extrema1, context: context)), nil, nil, nil)
//        UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: cg(image: extrema2, context: context)), nil, nil, nil)
        
        return extrema
    }
    
    func extractExtrema(diffLo: CIImage, diffTarget: CIImage, diffHi: CIImage, r: Double) -> CIImage{
        // Extrema extraction through comparison of 26(9+8+9) neighbors
        let comp26 = CIFilter(name: "extractExtrema")
        // First compare diffGauss1,2,3 | with diffGauss2 in the middle of stack
        comp26?.setValue(diffTarget, forKey: "inputImage")
        comp26?.setValue(diffLo, forKey: "inputComparison1")
        comp26?.setValue(diffHi, forKey: "inputComparison2")
    
        let ex = (comp26?.outputImage)!
        let edger = CIFilter(name: "edgeRejection")
        edger?.setValue(ex, forKey: "inputMap")
        edger?.setValue(diffTarget, forKey: "inputImage")
        edger?.setValue(r, forKey: "inputThreshold")
        let kp = (edger?.outputImage)!
        
        return kp
    }
    
    func detectSIFT(inputImage: CIImage, sigma: Double, k: Double, r: Double, numberExtrema: Int) {
        let image = rgb2gray(inputImage: inputImage)
//        let k = 1.41421356237 // sqrt(2)
        
        // initialization
        let blurredImage1 = gaussianBlur(inputImage: image, sigma: sigma)
        let blurredImage2 = gaussianBlur(inputImage: image, sigma: sigma * k)
        let blurredImage3 = gaussianBlur(inputImage: image, sigma: sigma * k * k)
        let diffGauss1    = diffOfGaussian(inputImageLo: blurredImage1, inputImageHi: blurredImage2)
        let diffGauss2    = diffOfGaussian(inputImageLo: blurredImage2, inputImageHi: blurredImage3)
        
        // finding keypoints
        var lastBlurred   = blurredImage3;
        var lastDiff1     = diffGauss1;
        var lastDiff2     = diffGauss2;
        var keypoints       = [CIImage]()
        for i in 1...numberExtrema {
            let b = gaussianBlur(inputImage: image, sigma: sigma * pow(k,Double(i+2)))
            let d = diffOfGaussian(inputImageLo: lastBlurred, inputImageHi: b)
            
            let kp = extractExtrema(diffLo: lastDiff1, diffTarget: lastDiff2, diffHi: d, r: r)
            keypoints.append(kp)
            
            lastBlurred = b
            lastDiff1   = lastDiff2
            lastDiff2   = d
        }

        // display
        let context = CIContext()
//        imageView2.image = UIImage(cgImage: cg(image: keypoints[0], context: context))
        imageView3.image = UIImage(cgImage: convertCIImagetoCGImage(image: keypoints[0], context: context))
//        imageView4.image = UIImage(cgImage: convertCIImagetoCGImage(image: keypoints[1], context: context))
//        imageView5.image = UIImage(cgImage: convertCIImagetoCGImage(image: keypoints[2], context: context))
//        imageView6.image = UIImage(cgImage: convertCIImagetoCGImage(image: keypoints[3], context: context))
        
        // saving photos to images
//        for i in 0...3 {
            saveAsPNG(image: keypoints[0], context: context)
//        }
       
        
//        // Gaussian Blur
//        var blurred = [CIImage]()
//        for i in 1...(numberExtrema+3){
//            let blur = gaussianBlur(inputImage: inputImage, sigma: sigma * pow(k, Double(i-1)))
//            blurred.append(blur)
//        }
//
//        // Difference of Gaussian
//        var diff = [CIImage]()
//        for i in 0...(blurred.count-2){
//            let b1 = blurred[i];
//            let b2 = blurred[i+1];
//            let d  = diffOfGaussian(inputImageLo: b1, inputImageHi: b2)
//            diff.append(d)
//        }
////        print(blurred)
////        let blurredImage1 = gaussianBlur(inputImage: blurred[1], sigma: blurred[2])
////        let blurredImage2 = gaussianBlur(inputImage: image, sigma: sigma * k)
//        let diffGauss1 = diffOfGaussian(inputImageLo: blurred[6], inputImageHi: blurred[7])
        
    }
  
    
    func findMagAndOri(image: CIImage) -> CIImage{
        let mNo = CIFilter(name: "magNori")
        mNo?.setValue(image, forKey: "inputImage")
        return (mNo?.outputImage)!
    }
    
    func findPeakOrientation(inputKP: CIImage, inputMO: CIImage, inputSigma: Double) -> CIImage{
        let peakFinder = CIFilter(name: "findPeak")
        peakFinder?.setValue(inputKP, forKey: "inputKP")
        peakFinder?.setValue(inputMO, forKey: "inputMagOri")
        peakFinder?.setValue(inputSigma, forKey: "inputSigma")
        return (peakFinder?.outputImage)!
    }

}
