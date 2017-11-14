//
//  extractExtrema.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/29/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef extractExtrema_h
#define extractExtrema_h
#import <CoreImage/CoreImage.h>

@interface extractExtrema: CIFilter
{
    CIImage   *inputImage;
    CIImage   *inputComparison1;
    CIImage   *inputComparison2;
    NSNumber  *inputSigma;
}

@end

#endif /* extractExtrema_h */
