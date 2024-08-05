//
//  ImageManager+ImageConversion.mm
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#import "ImageManager/ImageManager+ImageConversion.h"
#import <opencv2/Imgproc.h>

@implementation ImageManager (ImageConversion)

- (CGImageRef)Mat2CGImage:(cv::Mat)mat {
    // Convert cv::Mat to CGImageRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(mat.data,
                                                 mat.cols,
                                                 mat.rows,
                                                 8,
                                                 mat.step,
                                                 colorSpace,
                                                 kCGImageAlphaNone);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    // Release CG objects
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return cgImage;
}

- (cv::Mat)CGImage2Mat:(CGImageRef)cgImage {
    // Get the width and height of the image
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    // Create a bitmap context with the image's size and gray color space
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaNone);
    
    // Draw the CGImage into the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // Get the image data from the context
    void *data = CGBitmapContextGetData(context);
    if (data == NULL) {
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return cv::Mat(); // Return an empty cv::Mat if data is NULL
    }
    
    // Create a cv::Mat with the image data
    cv::Mat mat((int)height, (int)width, CV_8UC1, static_cast<uint8_t *>(data), bytesPerRow);
    cv::Mat ret;
    mat.copyTo(ret);
    
    // Release the CG objects
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return ret;
}

- (cv::Mat)adaptiveThreshold:(int)threshold
                  withKernel:(int)kernelSize
                     cgImage:(CGImageRef)cgImage {
    if ((void *)cgImage != (void *)_cgImage) { // new image
        _cgImage = cgImage;
        _matImage = [self CGImage2Mat:_cgImage];
        cv::integral(_matImage, _integralImage, CV_32S);
    } else if (_matImage.empty()) {
        _matImage = [self CGImage2Mat:_cgImage];
        cv::integral(_matImage, _integralImage, CV_32S);
    } else if (_integralImage.empty()) {
        cv::integral(_matImage, _integralImage, CV_32S);
    }
    
    // Ensure kernelSize is odd
    if (kernelSize % 2 == 0) {
        kernelSize += 1;
    }
    
    cv::Mat binaryAdaptive;
    cv::adaptiveThreshold(_matImage, binaryAdaptive, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, kernelSize, threshold);
    
    return binaryAdaptive;
}

@end
