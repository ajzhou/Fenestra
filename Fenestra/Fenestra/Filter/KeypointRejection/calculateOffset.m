//
//  calculateOffset.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "calculateOffset.h"

@implementation calculateOffset

static CIKernel *calculateOffsetKernel = nil;

- (id)init {
    if(calculateOffsetKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"calculateOffset"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        calculateOffsetKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * map = [CISampler samplerWithImage: inputMap];
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CISampler * hiImg = [CISampler samplerWithImage: inputHigherScaleImage];
    CISampler * hiHiImg = [CISampler samplerWithImage: inputHigherHigherScaleImage];
    CISampler * loImg = [CISampler samplerWithImage: inputLowerScaleImage];
    CISampler * loLoImg = [CISampler samplerWithImage: inputLowerLowerScaleImage];
    CGRect DOD = src.extent;
    
    return [calculateOffsetKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, -1, -1);
    } arguments: @[map,src,hiImg,hiHiImg,loImg,loLoImg]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Calculate Offset"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Calculate Offset Filter",
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
