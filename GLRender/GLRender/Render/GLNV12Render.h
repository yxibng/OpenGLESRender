//
//  GLNV12Render.h
//  GLRender
//
//  Created by yxibng on 2023/11/20.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

@interface GLNV12Render : NSObject
@property (nonatomic, assign) GLuint programHandle;
@property (nonatomic, assign) CGRect viewport;

@property (nonatomic, copy) NSString *vertexShader;
@property (nonatomic, copy) NSString *fragmentShader;

@property (nonatomic) CVOpenGLESTextureRef yTexture;
@property (nonatomic) CVOpenGLESTextureRef uvTexture;
@property (nonatomic) CVOpenGLESTextureRef targetTexture;



@end

NS_ASSUME_NONNULL_END
