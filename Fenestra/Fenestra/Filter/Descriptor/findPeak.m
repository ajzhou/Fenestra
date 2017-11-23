//
//  findPeak.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/16/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "findPeak.h"

@implementation findPeak

static CIKernel *kernel = nil;

- (id)init {
    if(kernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"findPeak"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        kernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * kp = [CISampler samplerWithImage: inputKP];
    CISampler * mn = [CISampler samplerWithImage: inputMagOri];
    CGRect DOD = kp.extent;
    
    return [kernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, -18, -18);
    } arguments: @[kp,mn,inputSigma]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Find Peak Orientation"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Find Peak Orientation Filter",
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
