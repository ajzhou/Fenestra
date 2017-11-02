//
//  lowConstrastRejection.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef lowConstrastRejection_h
#define lowConstrastRejection_h
#import <CoreImage/CoreImage.h>

@interface lowContrastRejection: CIFilter
{
    CIImage   *inputImage;
    CIImage   *inputComparison1;
    CIImage   *inputComparison2;
    NSNumber  *inputSigma;
}

@end


#endif /* lowConstrastRejection_h */
