//
//  gaussian1X.m
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/24/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gaussian1X.h"

@implementation gaussian1X
    
    static CIKernel *gaussian1XKernel = nil;
    
- (id)init {
    if(gaussian1XKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"gaussian1X"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        gaussian1XKernel = kernels[0];
    }
    
    return [super init];
}
    
- (CIImage *)outputImage
    {
        CISampler * src = [CISampler samplerWithImage: inputImage];
        CGRect      DOD = src.extent;
        NSNumber  * width = [NSNumber numberWithFloat:src.extent.size.width];
        NSNumber  * origin = [NSNumber numberWithFloat:src.extent.origin.x];
        
        return [gaussian1XKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
            return CGRectInset(destRect, -30, 0);
        } arguments: @[
                       src,
                       inputSigma,
                       width,
                       origin]];
    }
    
    // registration
+ (void)initialize
    {
        [CIFilter registerFilterName: @"Gaussian1X"
                         constructor: self
                     classAttributes:
         @{kCIAttributeFilterDisplayName : @"Gaussian_1D_X",
           kCIAttributeFilterCategories : @[
                   kCICategoryColorAdjustment, kCICategoryVideo,
                   kCICategoryStillImage, kCICategoryInterlaced,
                   kCICategoryNonSquarePixels]}
         ];
    }
    
    // Method that creates instance of filter
+ (CIFilter *)filterWithName: (NSString *)name
    {
        CIFilter  *filter;
        filter = [[self alloc] init];
        return filter;
    }
    
@end

