//
//  edgeRejection.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "edgeRejection.h"

@implementation edgeRejection

static CIKernel *edgeRejectionKernel = nil;

- (id)init {
    if(edgeRejectionKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"edgeRejection"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        edgeRejectionKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * map = [CISampler samplerWithImage: inputMap];
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CGRect DOD = src.extent;
    
    return [edgeRejectionKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, -1, -1);
    } arguments: @[map, src, inputThreshold]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Edge Rejection"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Edge Rejection Filter",
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
