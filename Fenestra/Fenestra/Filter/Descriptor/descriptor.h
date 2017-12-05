//
//  descriptor.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 12/5/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef descriptor_h
#define descriptor_h
#import <CoreImage/CoreImage.h>
@interface descriptor: CIFilter
{
    CIImage   *inputLocations;
    CIImage   *inputMagOri;
    NSNumber  *inputLength;
}

@end


#endif /* descriptor_h */
