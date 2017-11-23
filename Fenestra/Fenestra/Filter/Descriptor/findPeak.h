//
//  findPeak.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/16/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef findPeak_h
#define findPeak_h
#import <CoreImage/CoreImage.h>
@interface findPeak: CIFilter
{
    CIImage   *inputKP;
    CIImage   *inputMagOri;
    NSNumber  *inputSigma;
}

@end

#endif /* findPeak_h */
