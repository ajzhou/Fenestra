//
//  rgb2gray.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/30/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef rgb2gray_h
#define rgb2gray_h
#import <CoreImage/CoreImage.h>
@interface rgb2gray: CIFilter
{
    CIImage   *inputImage;
}

@end

#endif /* rgb2gray_h */
