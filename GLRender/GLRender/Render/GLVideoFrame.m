//
//  GLVideoFrame.m
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import "GLVideoFrame.h"

@interface GLVideoFrame ()

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) GLVideoRotation rotation;

@property (nonatomic) GLVideoFrameType videoFrameType;
@property (nonatomic) CVPixelBufferRef pixelBuffer;
@property (nonatomic) GLYUVPlanarBuffer * yuvPlanarBuffer;

@end

@implementation GLVideoFrame

- (void)dealloc {
    if (_pixelBuffer) CVPixelBufferRelease(_pixelBuffer);
}

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(GLVideoRotation)rotation {
    if (self = [super init]) {
        _pixelBuffer = CVBufferRetain(pixelBuffer);
        _width = (int)CVPixelBufferGetWidth(pixelBuffer);
        _height = (int)CVPixelBufferGetHeight(pixelBuffer);
        _videoFrameType = GLVideoFrameTypePixelBuffer;
        _rotation = rotation;
        if (CVPixelBufferGetPlaneCount(pixelBuffer) == 2) {
            _yuvType = GLYUVTypeNV12;
        } else if (CVPixelBufferGetPlaneCount(pixelBuffer) == 3) {
            _yuvType = GLYUVTypeI420;
        } else {
            NSAssert(NO, @"Not support!");
        }
    }
    return self;
    
}

- (instancetype)initWithYUVPlanarBuffer:(GLYUVPlanarBuffer *)yuvPlanarBuffer rotation:(GLVideoRotation)rotation {
    if (self = [super init]) {
        _yuvPlanarBuffer = yuvPlanarBuffer;
        _width = yuvPlanarBuffer.width;
        _height = yuvPlanarBuffer.height;
        _videoFrameType = GLVideoFrameTypeRawYUV;
        _rotation = rotation;
        _yuvType = yuvPlanarBuffer.yuvType;
    }
    return self;
}
@end
