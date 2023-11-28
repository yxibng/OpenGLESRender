//
//  GLI420TextureCache.h
//  GLRender
//
//  Created by yxibng on 2023/11/21.
//

#import <Foundation/Foundation.h>
#import "GLVideoFrame.h"
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLI420TextureCache : NSObject
@property(nonatomic, readonly) GLuint yTexture;
@property(nonatomic, readonly) GLuint uTexture;
@property(nonatomic, readonly) GLuint vTexture;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContext:(EAGLContext *)context NS_DESIGNATED_INITIALIZER;
- (void)uploadFrameToTextures:(GLVideoFrame*)frame;
- (void)releaseTextures;
@end

NS_ASSUME_NONNULL_END
