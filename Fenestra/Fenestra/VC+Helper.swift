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
        let loc = [1,2,3,4,5,6,7]
        test?.setValue(image, forKey: "inputImage")
        let output = (test?.outputImage)!
        let context = CIContext()
//        saveAsPNG(image: output, context: context)
    }
    
    func getKeypointLocationsFromImage(fromImage cgImage: CGImage) -> [(x: Int, y: Int)] {
        
        var result:[(x: Int, y: Int)] = []
        
        let x = 0
        let y = 0
        let width = cgImage.width
        let height = cgImage.height
        let count = width * height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawdata = calloc(height*width*4, MemoryLayout<CUnsignedChar>.size)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: rawdata, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("CGContext creation failed")
            return result
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Now your rawData contains the image data in the RGBA8888 pixel format.
        var byteIndex = bytesPerRow * y + bytesPerPixel * x
        
        for pos in 0..<count {
            let alpha = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 3, as: UInt8.self)) / 255.0
            let red = CGFloat(rawdata!.load(fromByteOffset: byteIndex, as: UInt8.self)) / 255.0
            let green = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 1, as: UInt8.self)) / 255.0
            let blue = CGFloat(rawdata!.load(fromByteOffset: byteIndex + 2, as: UInt8.self)) / 255.0
            byteIndex += bytesPerPixel
        
            if red != 0.0 || green != 0.0 {
            
                let color = CIColor(red: red, green: green, blue: blue, alpha: alpha)
                print(color)
                
//                let aColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                let col = pos % width
                let row = Int(floor(Double(pos) / Double(width))) // row
                
                result.append((x: col, y: row))
            }
        }
        
        free(rawdata)
        
        return result
    }
    
    func drawLocationImage(locations: [(x: Int, y: Int)]) -> CIImage {
//         https://developer.apple.com/library/content/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/HandlingImages/Images.html
        
        let width = 1
        let height = locations.count
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let MAX_MULTIPLE = 50.0
        let PALETTE = 255.0
        for i in 0..<height {
            let x = locations[i].x
            let y = locations[i].y
            
            // recover x: 255 * 50 * r + 255 * g | Make sure to unpremultiply
            let r = floor(Double(x) / PALETTE) / MAX_MULTIPLE
            let g = Double(x % Int(PALETTE)) / PALETTE
            // recover y: 255 * 50 * b + 255 * a | Make sure to unpremultiply
            let b = floor(Double(x) / PALETTE) / MAX_MULTIPLE
            let a = Double(y % Int(PALETTE)) / PALETTE
//            let a = 0.0
            let color = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a)).cgColor
            context?.setFillColor(color)
            let position = CGRect(x: 0, y: i, width: 1, height: 1)
            context?.fill(position)
            
            context?.saveGState() // is this necessary?
        }
        
        context?.restoreGState()
        let uiimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // figure out error handling
        
        let image = CIImage(image: uiimage!)
        return image!
    }
    
}
