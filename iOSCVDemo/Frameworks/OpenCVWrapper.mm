//
//  OpenCVWrapper.m
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#import <UIKit/UIKit.h>

#import "OpenCVWrapper.h"
#import "ImageManager+ImageConversion.h"

@implementation OpenCVWrapper

- (CGImageRef)adaptiveThreshold:(int)threshold
                    withKernel:(int)kernelSize
                       cgImage:(CGImageRef)cgImage {
    ImageManager *im = [ImageManager instance];
    
    cv::Mat adaptiveImage = [im adaptiveThreshold:threshold
                                withKernel:kernelSize
                                   cgImage:cgImage];
    
    CGImageRef ret = [im Mat2CGImage:adaptiveImage];
    
    return ret;
}

@end
