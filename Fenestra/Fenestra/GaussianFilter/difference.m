//
//  difference.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/29/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "difference.h"

@implementation difference

static CIKernel *differenceKernel = nil;

- (id)init {
    if(differenceKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"difference"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        differenceKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * imgLo = [CISampler samplerWithImage: inputImageLo];
    CISampler * imgHi = [CISampler samplerWithImage: inputImageHi];
    CGRect DOD = imgLo.extent;
    
    return [differenceKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, 0, 0);
    } arguments: @[imgLo, imgHi]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Difference"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Difference Filter",
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
