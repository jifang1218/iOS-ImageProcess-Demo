//
//  ImageManagerBase.m
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

#import "ImageManager/ImageManagerBase.h"

@implementation ImageManager

- (id)init {
    self = [super init];
    _cgImage = NULL;
    
    return self;
}
    
+ (ImageManager *)instance {
    static ImageManager *ret = nil;
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ret = [[self alloc] init];
        });
    
    return ret;
}

@end
