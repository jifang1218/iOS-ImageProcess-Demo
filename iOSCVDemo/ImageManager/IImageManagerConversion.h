//
//  IImageManagerConversion.h
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#ifndef IImageManagerConvertion_h
#define IImageManagerConvertion_h

#import <opencv2/Core.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ImageManager/IImageManagerBase.h"

@class UIImage;

@protocol IImageManagerConversion <IImageManagerBase>

- (cv::Mat)CGImage2Mat:(CGImageRef)cgImage;
- (CGImageRef)Mat2CGImage:(cv::Mat)mat;
- (cv::Mat)adaptiveThreshold:(int)threshold
                  withKernel:(int)kernelSize
                     cgImage:(CGImageRef)cgImage;

@end

#endif /* IImageManagerConversion_h */
