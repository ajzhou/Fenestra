//
//  extremumLocalization.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "extremumLocalization.h"

@implementation extremumLocalization

static CIKernel *extremumLocalizationKernel = nil;

- (id)init {
    if(extremumLocalizationKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"extremumLocalization"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        extremumLocalizationKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * map = [CISampler samplerWithImage: inputMap];
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CISampler * hiImg = [CISampler samplerWithImage: inputHigherScaleImage];
    CISampler * loImg = [CISampler samplerWithImage: inputLowerScaleImage];
    CGRect DOD = src.extent;
    
    return [extremumLocalizationKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, -3 * [inputSigma floatValue], -3 * [inputSigma floatValue]);
    } arguments: @[map, src, hiImg, loImg, inputSigma]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Extremum Localization"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Extremum Localization Filter",
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
