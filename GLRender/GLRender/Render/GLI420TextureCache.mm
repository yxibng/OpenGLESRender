//
//  GLI420TextureCache.m
//  GLRender
//
//  Created by yxibng on 2023/11/21.
//

#import "GLI420TextureCache.h"

// Two sets of 3 textures are used here, one for each of the Y, U and V planes. Having two sets
// alleviates CPU blockage in the event that the GPU is asked to render to a texture that is already
// in use.
static const GLsizei kNumTextureSets = 2;
static const GLsizei kNumTexturesPerSet = 3;
static const GLsizei kNumTextures = kNumTexturesPerSet * kNumTextureSets;


@implementation GLI420TextureCache {
    
}






@end
