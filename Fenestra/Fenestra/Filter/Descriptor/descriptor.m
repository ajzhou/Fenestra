//
//  descriptor.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 12/5/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "descriptor.h"

@implementation descriptor

static CIKernel *kernel = nil;

- (id)init {
    if(kernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"descriptor"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        kernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * locImg = [CISampler samplerWithImage: inputLocations];
    CISampler * mn = [CISampler samplerWithImage: inputMagOri];
    CGRect DOD = CGRectMake(0.0, 0.0, 128.0, inputLength.doubleValue);
    
    return [kernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        if (index == 0) {
            return CGRectMake(0.0, destRect.origin.y, 1.0, destRect.size.height);
        } else {
            return mn.extent;
        }
    } arguments: @[locImg,mn,inputLength,inputSigma]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"SIFT Descriptor"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"SIFT Descriptor Filter",
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
