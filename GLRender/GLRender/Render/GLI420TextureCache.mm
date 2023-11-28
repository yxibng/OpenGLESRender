//
//  GLI420TextureCache.m
//  GLRender
//
//  Created by yxibng on 2023/11/21.
//

#import "GLI420TextureCache.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#include <vector>

// Two sets of 3 textures are used here, one for each of the Y, U and V planes. Having two sets
// alleviates CPU blockage in the event that the GPU is asked to render to a texture that is already
// in use.
static const GLsizei kNumTextureSets = 2;
static const GLsizei kNumTexturesPerSet = 3;
static const GLsizei kNumTextures = kNumTexturesPerSet * kNumTextureSets;


@implementation GLI420TextureCache {
    BOOL _hasUnpackRowLength;
    GLint _currentTextureSet;
    // Handles for OpenGL constructs.
    GLuint _textures[kNumTextures];
    // Used to create a non-padded plane for GPU upload when we receive padded frames.
    std::vector<uint8_t> _planeBuffer;
}

- (void)dealloc {
    glDeleteTextures(kNumTextures, _textures);
}


- (GLuint)yTexture {
    return _textures[_currentTextureSet * kNumTexturesPerSet];
}

- (GLuint)uTexture {
    return _textures[_currentTextureSet * kNumTexturesPerSet + 1];
}

- (GLuint)vTexture {
    return _textures[_currentTextureSet * kNumTexturesPerSet + 2];
}

- (instancetype)initWithContext:(EAGLContext *)context {
    if (self = [super init]) {
        _hasUnpackRowLength = (context.API == kEAGLRenderingAPIOpenGLES3);
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        
        [self setupTextures];
    }
    return self;
}

- (void)setupTextures {
    glGenTextures(kNumTextures, _textures);
    // Set parameters for each of the textures we created.
    for (GLsizei i = 0; i < kNumTextures; i++) {
        glBindTexture(GL_TEXTURE_2D, _textures[i]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }
}


- (void)uploadPlane:(const uint8_t *)plane
            texture:(GLuint)texture
              width:(size_t)width
             height:(size_t)height
             stride:(int32_t)stride {
    glBindTexture(GL_TEXTURE_2D, texture);
    
    const uint8_t *uploadPlane = plane;
    if ((size_t)stride != width) {
        if (_hasUnpackRowLength) {
            // GLES3 allows us to specify stride.
            glPixelStorei(GL_UNPACK_ROW_LENGTH, stride);
            glTexImage2D(GL_TEXTURE_2D,
                         0,
                         GL_LUMINANCE,
                         static_cast<GLsizei>(width),
                         static_cast<GLsizei>(height),
                         0,
                         GL_LUMINANCE,
                         GL_UNSIGNED_BYTE,
                         uploadPlane);
            glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
            return;
        } else {
            // Make an unpadded copy and upload that instead. Quick profiling showed
            // that this is faster than uploading row by row using glTexSubImage2D.
            uint8_t *unpaddedPlane = _planeBuffer.data();
            for (size_t y = 0; y < height; ++y) {
                memcpy(unpaddedPlane + y * width, plane + y * stride, width);
            }
            uploadPlane = unpaddedPlane;
        }
    }
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_LUMINANCE,
                 static_cast<GLsizei>(width),
                 static_cast<GLsizei>(height),
                 0,
                 GL_LUMINANCE,
                 GL_UNSIGNED_BYTE,
                 uploadPlane);
}

- (void)uploadFrameToTextures:(GLVideoFrame *)frame {
    
    _currentTextureSet = (_currentTextureSet + 1) % kNumTextureSets;
    
    if (frame.videoFrameType == GLVideoFrameTypePixelBuffer) {
        uint8_t *y, *u, *v;
        int width, height, stride_y, stride_u, stride_v;
        
        OSType pixelFormatType = CVPixelBufferGetPixelFormatType(frame.pixelBuffer);
        NSAssert(pixelFormatType == kCVPixelFormatType_420YpCbCr8Planar || pixelFormatType == kCVPixelFormatType_420YpCbCr8PlanarFullRange, @"PixelFormat not match!");
        
        CVPixelBufferLockBaseAddress(frame.pixelBuffer, 0);
        
        width = (int)CVPixelBufferGetWidth(frame.pixelBuffer);
        height = (int)CVPixelBufferGetHeight(frame.pixelBuffer);
        
        y = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(frame.pixelBuffer, 0);
        u = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(frame.pixelBuffer, 1);
        v = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(frame.pixelBuffer, 2);
        
        stride_y = (int)CVPixelBufferGetBytesPerRowOfPlane(frame.pixelBuffer, 0);
        stride_u = (int)CVPixelBufferGetBytesPerRowOfPlane(frame.pixelBuffer, 1);
        stride_v = (int)CVPixelBufferGetBytesPerRowOfPlane(frame.pixelBuffer, 2);
        
        [self uploadPlane:y
                  texture:self.yTexture
                    width:width
                   height:height
                   stride:stride_y];
        
        [self uploadPlane:u
                  texture:self.uTexture
                    width:width/2
                   height:height/2
                   stride:stride_u];
        
        [self uploadPlane:v
                  texture:self.vTexture
                    width:width/2
                   height:height/2
                   stride:stride_v];
        
        CVPixelBufferUnlockBaseAddress(frame.pixelBuffer, 0);
        return;
        
    } else {
        NSAssert(frame.yuvPlanarBuffer.yuvType == GLYUVTypeI420, @"yuvPlanarBuffer.yuvType not match!");
        
        [self uploadPlane:frame.yuvPlanarBuffer.dataY
                  texture:self.yTexture
                    width:frame.yuvPlanarBuffer.width
                   height:frame.yuvPlanarBuffer.height
                   stride:frame.yuvPlanarBuffer.strideY];
        
        [self uploadPlane:frame.yuvPlanarBuffer.dataU
                  texture:self.uTexture
                    width:frame.yuvPlanarBuffer.width/2
                   height:frame.yuvPlanarBuffer.height/2
                   stride:frame.yuvPlanarBuffer.strideU];
        
        [self uploadPlane:frame.yuvPlanarBuffer.dataV
                  texture:self.vTexture
                    width:frame.yuvPlanarBuffer.width/2
                   height:frame.yuvPlanarBuffer.height/2
                   stride:frame.yuvPlanarBuffer.strideV];
        
    }
}


- (void)releaseTextures {
    
}

@end
