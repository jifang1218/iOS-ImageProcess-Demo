//
//  ImageManager+ImageConversion.h
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#import "ImageManager/ImageManagerBase.h"
#import "ImageManager/IImageManagerConversion.h"
#import <opencv2/Core.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageManager (ImageConversion) <IImageManagerConversion>

- (cv::Mat)CGImage2Mat:(CGImageRef)cgImage;
- (CGImageRef)Mat2CGImage:(cv::Mat)mat;
- (cv::Mat)adaptiveThreshold:(int)threshold
                     withKernel:(int)kernelSize
                        cgImage:(CGImageRef)cgImage;

@end

NS_ASSUME_NONNULL_END
