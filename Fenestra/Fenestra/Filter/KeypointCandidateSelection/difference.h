//
//  difference.h
//  Fenestra
//
//  Created by Andrew Jay Zhou on 10/29/17.
//  Copyright © 2017 Andrew Jay Zhou. All rights reserved.
//

#ifndef difference_h
#define difference_h
#import <CoreImage/CoreImage.h>

@interface difference: CIFilter
{
    CIImage   *inputImageLo;
    CIImage   *inputImageHi;
}

@end

#endif /* difference_h */
