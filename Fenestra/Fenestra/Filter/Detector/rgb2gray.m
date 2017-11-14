//
//  rgb2gray.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/30/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rgb2gray.h"

@implementation rgb2gray

static CIKernel *rgb2grayKernel = nil;

- (id)init {
    if(rgb2grayKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"rgb2gray"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        rgb2grayKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CGRect DOD = src.extent;
    
    return [rgb2grayKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, 0, 0);
    } arguments: @[src]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"rgb2gray"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"rgb2gray Filter",
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
