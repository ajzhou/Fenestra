//
//  gaussian1X.h
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/24/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef gaussian1X_h
#define gaussian1X_h
#import <CoreImage/CoreImage.h>

@interface gaussian1X: CIFilter
{
    CIImage   *inputImage;
    NSNumber  *inputSigma;
    NSNumber  *inputRadius;
}

@end

#endif /* gaussian1X_h */

