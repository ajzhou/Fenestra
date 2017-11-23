//
//  VC+Helper.swift
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/22/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func saveAsPNG(image: CIImage, context: CIContext) {
        var img = UIImage(cgImage: convertCIImagetoCGImage(image: image, context: context))
        guard let pngData = UIImagePNGRepresentation(img) else {
            print("Cannot be represented as PNG")
            return
        }
        img = UIImage(data: pngData)!
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
    }
    
    func convertCIImagetoCGImage(image: CIImage, context: CIContext) -> CGImage{
        return context.createCGImage(image, from: image.extent)!
    }
    
    func testKernel(image: CIImage) {
        let test = CIFilter(name: "test")
        // First compare diffGauss1,2,3 | with diffGauss2 in the middle of stack
        test?.setValue(image, forKey: "inputImage")
        let output = (test?.outputImage)!
        let context = CIContext()
        saveAsPNG(image: output, context: context)
    }
    
}
