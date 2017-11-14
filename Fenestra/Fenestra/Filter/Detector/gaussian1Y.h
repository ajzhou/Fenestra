//
//  gaussian1Y.h
//  CIKernel
//
//  Created by Andrew Jay Zhou on 10/24/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef gaussian1Y_h
#define gaussian1Y_h
#import <CoreImage/CoreImage.h>

@interface gaussian1Y: CIFilter
    {
        CIImage   *inputImage;
        NSNumber  *inputSigma;
    }
    
@end

#endif /* gaussian1Y_h */

