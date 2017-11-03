//
//  extremumLocalization.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef extremumLocalization_h
#define extremumLocalization_h
#import <CoreImage/CoreImage.h>

@interface extremumLocalization: CIFilter
{
    CIImage   *inputMap;
    CIImage   *inputImage;
    CIImage   *inputHigherScaleImage; 
    CIImage   *inputLowerScaleImage;
    NSNumber  *inputSigma; 
}

@end

#endif /* extremumLocalization_h */
