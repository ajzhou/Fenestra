//
//  halve.m
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/24/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "halve.h"

@implementation halve

static CIKernel *halveKernel = nil;

- (id)init {
    if(halveKernel == nil)
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"halve"
                                                             ofType:@"cikernel"];
        NSString    *code = [NSString stringWithContentsOfFile:fullPath encoding: NSASCIIStringEncoding error: NULL];
        
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        halveKernel = kernels[0];
    }
    return [super init];
}

- (CIImage *)outputImage
{
    CISampler * src = [CISampler samplerWithImage: inputImage];
    CIVector *offset = [CIVector vectorWithX:src.extent.origin.x
                                           Y:src.extent.origin.y];
    CGRect DOD = CGRectMake(src.extent.origin.x, src.extent.origin.y, src.extent.size.width/2, src.extent.size.height/2);
    
    return [halveKernel applyWithExtent:DOD roiCallback:^CGRect(int index, CGRect destRect) {
        return CGRectMake(destRect.origin.x, destRect.origin.y, destRect.size.width * 2, destRect.size.height * 2);
    } arguments: @[src, offset]];
}

// registration
+ (void)initialize
{
    [CIFilter registerFilterName: @"Halve"
                     constructor: self
                 classAttributes:
     @{kCIAttributeFilterDisplayName : @"Halve Filter",
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

