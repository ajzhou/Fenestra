//
//  test.m
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/22/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "test.h"

@implementation test

static CIKernel *kernel = nil;

- (id)init {
    if(kernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"test"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        kernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CGRect DOD = src.extent;
    
    return [kernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectInset(destRect, 0, 0);
    } arguments: @[src]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Test"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Test Filter",
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
