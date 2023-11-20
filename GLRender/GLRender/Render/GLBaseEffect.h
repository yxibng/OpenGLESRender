//
//  GLBaseEffect.h
//  GLRender
//
//  Created by yxibng on 2023/11/20.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

@interface GLBaseEffect : NSObject

@property (nonatomic, assign) GLuint programHandle;

@property (nonatomic, assign) CGRect viewport;

- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;

- (void)prepareToDraw;

@end

NS_ASSUME_NONNULL_END
