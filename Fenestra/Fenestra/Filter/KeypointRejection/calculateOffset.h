//
//  calculateOffset.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 11/1/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef calculateOffset_h
#define calculateOffset_h
#import <CoreImage/CoreImage.h>

@interface calculateOffset: CIFilter
{
    CIImage   *inputMap;
    CIImage   *inputImage;
    CIImage   *inputHigherScaleImage;
    CIImage   *inputHigherHigherScaleImage;
    CIImage   *inputLowerScaleImage;
    CIImage   *inputLowerLowerScaleImage;
}

@end


#endif /* calculateOffset_h */
