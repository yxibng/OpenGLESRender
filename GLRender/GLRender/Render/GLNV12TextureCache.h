//
//  GLNV12TextureCache.h
//  GLRender
//
//  Created by yxibng on 2023/11/21.
//

#import "GLVideoFrame.h"
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLNV12TextureCache : NSObject
@property(nonatomic, readonly) GLuint yTexture;
@property(nonatomic, readonly) GLuint uvTexture;

- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithContext:(EAGLContext *)context NS_DESIGNATED_INITIALIZER;

- (BOOL)uploadFrameToTextures:(GLVideoFrame *)frame;

- (void)releaseTextures;
@end

NS_ASSUME_NONNULL_END
