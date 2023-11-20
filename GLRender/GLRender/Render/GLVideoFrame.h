//
//  GLVideoFrame.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import <Foundation/Foundation.h>
#import "GLYUVPlanarBuffer.h"
@import CoreVideo;

typedef enum : NSUInteger {
    GLRotation0,
    GLRotation90,
    GLRotation180,
    GLRotation270
} GLRotation;

typedef enum : NSUInteger {
    GLVideoFrameTypeRawYUV,
    GLVideoFrameTypePixelBuffer
} GLVideoFrameType;


NS_ASSUME_NONNULL_BEGIN

@interface GLVideoFrame : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) GLRotation rotation;

@property (nonatomic, readonly) GLVideoFrameType videoFrameType;
@property (nonatomic, readonly) CVPixelBufferRef pixelBuffer;
@property (nonatomic, readonly) GLYUVPlanarBuffer * yuvPlanarBuffer;

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(GLRotation)rotation;

- (instancetype)initWithYUVPlanarBuffer:(GLYUVPlanarBuffer *)yuvPlanarBuffer rotation:(GLRotation)rotation;

@end

NS_ASSUME_NONNULL_END
