//
//  ImageManagerBase.h
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#ifndef ImageManagerBase_h
#define ImageManagerBase_h

#import <CoreGraphics/CoreGraphics.h>
#import <opencv2/opencv2.h>

@interface ImageManager : NSObject {
    CGImageRef _cgImage;
    cv::Mat _integralImage;
    cv::Mat _matImage;
}

- (id)init;

+ (ImageManager *)instance;

@end

#endif /* ImageManagerBase_h */
