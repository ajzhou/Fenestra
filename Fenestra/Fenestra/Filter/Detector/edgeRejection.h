//
//  edgeRejection.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef edgeRejection_h
#define edgeRejection_h
#import <CoreImage/CoreImage.h>

@interface edgeRejection: CIFilter
{
    CIImage   *inputMap;
    CIImage   *inputImage;
    CIImage   *inputThreshold;
}

@end


#endif /* edgeRejection_h */
