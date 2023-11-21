//
//  GLVideoFrame.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import "GLDefines.h"
#import "GLYUVPlanarBuffer.h"
#import <CoreVideo/CoreVideo.h>

typedef enum : NSUInteger {
    GLVideoFrameTypeRawYUV,
    GLVideoFrameTypePixelBuffer
} GLVideoFrameType;

NS_ASSUME_NONNULL_BEGIN

@interface GLVideoFrame : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) GLVideoRotation rotation;

@property (nonatomic, readonly) GLVideoFrameType videoFrameType;
@property (nonatomic, readonly) CVPixelBufferRef pixelBuffer;
@property (nonatomic, readonly) GLYUVPlanarBuffer * yuvPlanarBuffer;

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(GLVideoRotation)rotation;

- (instancetype)initWithYUVPlanarBuffer:(GLYUVPlanarBuffer *)yuvPlanarBuffer rotation:(GLVideoRotation)rotation;

@end

NS_ASSUME_NONNULL_END
