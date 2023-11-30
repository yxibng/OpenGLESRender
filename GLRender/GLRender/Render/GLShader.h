//
//  GLShader.h
//  GLRender
//
//  Created by yxibng on 2023/11/20.
//

#import <Foundation/Foundation.h>
#import "GLDefines.h"
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN GLuint GLCreateShader(GLenum type, const GLchar* source);
FOUNDATION_EXTERN GLuint GLCreateProgram(GLuint vertexShader, GLuint fragmentShader);
FOUNDATION_EXTERN GLuint GLCreateProgramForI420(void);
FOUNDATION_EXTERN GLuint GLCreateProgramForNV12(void);
FOUNDATION_EXTERN BOOL GLCreateVertexBuffer(GLuint* vertexBuffer,
                                            GLuint* vertexArray);
FOUNDATION_EXTERN void GLSetVertexData(GLVideoRotation rotation);




@interface GLShader : NSObject

@property (nonatomic, assign) CGSize drawSize;
@property (nonatomic, assign) GLVideoGravity videoGravity;

/** Callback for I420 frames. Each plane is given as a texture. */
- (void)applyShadingForFrameWithWidth:(int)width
                               height:(int)height
                             rotation:(GLVideoRotation)rotation
                               yPlane:(GLuint)yPlane
                               uPlane:(GLuint)uPlane
                               vPlane:(GLuint)vPlane;

/** Callback for NV12 frames. Each plane is given as a texture. */
- (void)applyShadingForFrameWithWidth:(int)width
                               height:(int)height
                             rotation:(GLVideoRotation)rotation
                               yPlane:(GLuint)yPlane
                              uvPlane:(GLuint)uvPlane;

@end



NS_ASSUME_NONNULL_END



