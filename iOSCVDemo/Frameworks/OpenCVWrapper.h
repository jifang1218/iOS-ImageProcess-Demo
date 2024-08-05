//
//  OpenCVWrapper.h
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <CoreGraphics/CoreGraphics.h>
#import <opencv2/Core.h>

@interface OpenCVWrapper : NSObject 

- (CGImageRef)adaptiveThreshold:(int)threshold
                     withKernel:(int)kernelSize
                        cgImage:(CGImageRef)cgImage;

@end

#endif /* OpenCVWrapper_h */
