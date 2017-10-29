//
//  gaussian1Y.m
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/24/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gaussian1Y.h"

@implementation gaussian1Y

static CIKernel *gaussian1YKernel = nil;

- (id)init {
    if(gaussian1YKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"gaussian1Y"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        gaussian1YKernel = kernels[0];
    }
    
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * src = [CISampler samplerWithImage: inputImage];
    //    CGRect DOD = CGRectInset(src.extent, 0, -30);
    CGRect DOD = src.extent;
    
    return [gaussian1YKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, 0, -30);
    } arguments: @[
                   src,
                   inputSigma]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Gaussian1Y"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Gaussian_1D_Y",
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

