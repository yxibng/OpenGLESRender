//
//  GLShader.m
//  GLRender
//
//  Created by yxibng on 2023/11/20.
//

#import "GLShader.h"
#import <GLKit/GLKit.h>
#include <memory>
#include <iostream>
#import <OpenGLES/ES3/gl.h>
#import "GLDefines.h"


static const int kYTextureUnit = 0;
static const int kUTextureUnit = 1;
static const int kVTextureUnit = 2;
static const int kUvTextureUnit = 1;


// Compiles a shader of the given `type` with GLSL source `source` and returns
// the shader handle or 0 on error.
GLuint GLCreateShader(GLenum type, const GLchar *source) {
    GLuint shader = glCreateShader(type);
    if (!shader) {
        return 0;
    }
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    GLint compileStatus = GL_FALSE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    if (compileStatus == GL_FALSE) {
        GLint logLength = 0;
        // The null termination character is included in the returned log length.
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            std::unique_ptr<char[]> compileLog(new char[logLength]);
            // The returned string is null terminated.
            glGetShaderInfoLog(shader, logLength, NULL, compileLog.get());
            std::cout  << "Shader compile error: " << compileLog.get();
        }
        glDeleteShader(shader);
        shader = 0;
    }
    return shader;
}

// Links a shader program with the given vertex and fragment shaders and
// returns the program handle or 0 on error.
GLuint GLCreateProgram(GLuint vertexShader, GLuint fragmentShader) {
    if (vertexShader == 0 || fragmentShader == 0) {
        return 0;
    }
    GLuint program = glCreateProgram();
    if (!program) {
        return 0;
    }
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    GLint linkStatus = GL_FALSE;
    glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        glDeleteProgram(program);
        program = 0;
    }
    return program;
}


NSString *fragmentSouceCode(NSString *name) {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"glsl"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}



// Creates and links a shader program with the given fragment shader source and
// a plain vertex shader. Returns the program handle or 0 on error.
GLuint GLCreateProgramForNV12() {
    NSString *vertexCode = fragmentSouceCode(@"NV12Vertex");
    NSString *fragmentCode = fragmentSouceCode(@"NV12Fragment");
    GLuint vertexShader = GLCreateShader(GL_VERTEX_SHADER, [vertexCode cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!vertexShader) {
        NSLog(@"failed to create vertex shader");
        return vertexShader;
    }
    GLuint fragmentShader =
    GLCreateShader(GL_FRAGMENT_SHADER, [fragmentCode cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!fragmentShader) {
        NSLog(@"failed to create fragment shader");
        return vertexShader;
    }
    
    GLuint program = GLCreateProgram(vertexShader, fragmentShader);
    // Shaders are created only to generate program.
    if (vertexShader) {
        glDeleteShader(vertexShader);
    }
    if (fragmentShader) {
        glDeleteShader(fragmentShader);
    }
    
    // Set vertex shader variables 'position' and 'texcoord' in program.
    GLint position = glGetAttribLocation(program, "position");
    GLint texcoord = glGetAttribLocation(program, "texcoord");
    if (position < 0 || texcoord < 0) {
        glDeleteProgram(program);
        return 0;
    }
    
    // Read position attribute with size of 2 and stride of 4 beginning at the start of the array. The
    // last argument indicates offset of data within the vertex buffer.
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (void *)0);
    glEnableVertexAttribArray(position);
    
    // Read texcoord attribute  with size of 2 and stride of 4 beginning at the first texcoord in the
    // array. The last argument indicates offset of data within the vertex buffer.
    glVertexAttribPointer(
                          texcoord, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (void *)(2 * sizeof(GLfloat)));
    glEnableVertexAttribArray(texcoord);
    
    return program;
}

GLuint GLCreateProgramForI420() {
    NSString *vertexCode = fragmentSouceCode(@"I420Vertex");
    NSString *fragmentCode = fragmentSouceCode(@"I420Fragment");
    GLuint vertexShader = GLCreateShader(GL_VERTEX_SHADER, [vertexCode cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!vertexShader) {
        NSLog(@"failed to create vertex shader");
        return vertexShader;
    }
    GLuint fragmentShader =
    GLCreateShader(GL_FRAGMENT_SHADER, [fragmentCode cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!fragmentShader) {
        NSLog(@"failed to create fragment shader");
        return vertexShader;
    }
    
    GLuint program = GLCreateProgram(vertexShader, fragmentShader);
    // Shaders are created only to generate program.
    if (vertexShader) {
        glDeleteShader(vertexShader);
    }
    if (fragmentShader) {
        glDeleteShader(fragmentShader);
    }
    
    // Set vertex shader variables 'position' and 'texcoord' in program.
    GLint position = glGetAttribLocation(program, "position");
    GLint texcoord = glGetAttribLocation(program, "texcoord");
    if (position < 0 || texcoord < 0) {
        glDeleteProgram(program);
        return 0;
    }
    
    // Read position attribute with size of 2 and stride of 4 beginning at the start of the array. The
    // last argument indicates offset of data within the vertex buffer.
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (void *)0);
    glEnableVertexAttribArray(position);
    
    // Read texcoord attribute  with size of 2 and stride of 4 beginning at the first texcoord in the
    // array. The last argument indicates offset of data within the vertex buffer.
    glVertexAttribPointer(
                          texcoord, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (void *)(2 * sizeof(GLfloat)));
    glEnableVertexAttribArray(texcoord);
    
    return program;
}



BOOL GLCreateVertexBuffer(GLuint *vertexBuffer, GLuint *vertexArray) {
    glGenBuffers(1, vertexBuffer);
    if (*vertexBuffer == 0) {
        glDeleteVertexArrays(1, vertexArray);
        return NO;
    }
    glBindBuffer(GL_ARRAY_BUFFER, *vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, 4 * 4 * sizeof(GLfloat), NULL, GL_DYNAMIC_DRAW);
    return YES;
}

// Set vertex data to the currently bound vertex buffer.
void GLSetVertexData(GLVideoRotation rotation) {
    // When modelview and projection matrices are identity (default) the world is
    // contained in the square around origin with unit size 2. Drawing to these
    // coordinates is equivalent to drawing to the entire screen. The texture is
    // stretched over that square using texture coordinates (u, v) that range
    // from (0, 0) to (1, 1) inclusive. Texture coordinates are flipped vertically
    // here because the incoming frame has origin in upper left hand corner but
    // OpenGL expects origin in bottom left corner.
    std::array<std::array<GLfloat, 2>, 4> UVCoords = {{
        {{0, 1}},  // Lower left.
        {{1, 1}},  // Lower right.
        {{1, 0}},  // Upper right.
        {{0, 0}},  // Upper left.
    }};
    
    // Rotate the UV coordinates.
    int rotation_offset;
    switch (rotation) {
        case GLVideoRotation0:
            rotation_offset = 0;
            break;
        case GLVideoRotation90:
            rotation_offset = 1;
            break;
        case GLVideoRotation180:
            rotation_offset = 2;
            break;
        case GLVideoRotation270:
            rotation_offset = 3;
            break;
    }
    std::rotate(UVCoords.begin(), UVCoords.begin() + rotation_offset,
                UVCoords.end());
    
    const GLfloat gVertices[] = {
        // X, Y, U, V.
        -1, -1, UVCoords[0][0], UVCoords[0][1],
        1, -1, UVCoords[1][0], UVCoords[1][1],
        1,  1, UVCoords[2][0], UVCoords[2][1],
        -1,  1, UVCoords[3][0], UVCoords[3][1],
    };
    
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(gVertices), gVertices);
}


@implementation GLShader {
    GLuint _vertexBuffer;
    GLuint _vertexArray;
    GLVideoRotation _currentRotation;
    
    GLuint _i420Program;
    GLuint _nv12Program;
}

- (void)dealloc {
    glDeleteProgram(_i420Program);
    glDeleteProgram(_nv12Program);
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArrays(1, &_vertexArray);
}



- (BOOL)createAndSetupI420Program {
    NSAssert(!_i420Program, @"I420 program already created");
    _i420Program = GLCreateProgramForI420();
    if (!_i420Program) {
        return NO;
    }
    GLint ySampler = glGetUniformLocation(_i420Program, "s_textureY");
    GLint uSampler = glGetUniformLocation(_i420Program, "s_textureU");
    GLint vSampler = glGetUniformLocation(_i420Program, "s_textureV");
    
    if (ySampler < 0 || uSampler < 0 || vSampler < 0) {
        NSLog(@"Failed to get uniform variable locations in I420 shader");
        glDeleteProgram(_i420Program);
        _i420Program = 0;
        return NO;
    }
    
    glUseProgram(_i420Program);
    glUniform1i(ySampler, kYTextureUnit);
    glUniform1i(uSampler, kUTextureUnit);
    glUniform1i(vSampler, kVTextureUnit);
    
    return YES;
}

- (BOOL)createAndSetupNV12Program {
    NSAssert(!_nv12Program, @"NV12 program already created");
    _nv12Program = GLCreateProgramForNV12();
    if (!_nv12Program) {
        return NO;
    }
    GLint ySampler = glGetUniformLocation(_nv12Program, "s_textureY");
    GLint uvSampler = glGetUniformLocation(_nv12Program, "s_textureUV");
    
    if (ySampler < 0 || uvSampler < 0) {
        NSLog(@"Failed to get uniform variable locations in NV12 shader");
        glDeleteProgram(_nv12Program);
        _nv12Program = 0;
        return NO;
    }
    
    glUseProgram(_nv12Program);
    glUniform1i(ySampler, kYTextureUnit);
    glUniform1i(uvSampler, kUvTextureUnit);
    
    return YES;
}

- (BOOL)prepareVertexBufferWithRotation:(GLVideoRotation)rotation {
    if (!_vertexBuffer && !GLCreateVertexBuffer(&_vertexBuffer, &_vertexArray)) {
        NSLog(@"Failed to setup vertex buffer");
        return NO;
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    if (_currentRotation != rotation) {
        _currentRotation = rotation;
        GLSetVertexData(rotation);
    }
    
    return YES;
}

- (void)applyShadingForFrameWithWidth:(int)width
                               height:(int)height
                             rotation:(GLVideoRotation)rotation
                               yPlane:(GLuint)yPlane
                               uPlane:(GLuint)uPlane
                               vPlane:(GLuint)vPlane {
    if (![self prepareVertexBufferWithRotation:rotation]) {
        return;
    }
    
    if (!_i420Program && ![self createAndSetupI420Program]) {
        NSLog(@"Failed to setup I420 program");
        return;
    }
    
    glUseProgram(_i420Program);
    
    glActiveTexture(static_cast<GLenum>(GL_TEXTURE0 + kYTextureUnit));
    glBindTexture(GL_TEXTURE_2D, yPlane);
    
    glActiveTexture(static_cast<GLenum>(GL_TEXTURE0 + kUTextureUnit));
    glBindTexture(GL_TEXTURE_2D, uPlane);
    
    glActiveTexture(static_cast<GLenum>(GL_TEXTURE0 + kVTextureUnit));
    glBindTexture(GL_TEXTURE_2D, vPlane);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

- (void)applyShadingForFrameWithWidth:(int)width
                               height:(int)height
                             rotation:(GLVideoRotation)rotation
                               yPlane:(GLuint)yPlane
                              uvPlane:(GLuint)uvPlane {
    if (![self prepareVertexBufferWithRotation:rotation]) {
        return;
    }
    
    if (!_nv12Program && ![self createAndSetupNV12Program]) {
        NSLog(@"Failed to setup NV12 shader");
        return;
    }
    
    glUseProgram(_nv12Program);
    
    glActiveTexture(static_cast<GLenum>(GL_TEXTURE0 + kYTextureUnit));
    glBindTexture(GL_TEXTURE_2D, yPlane);
    
    glActiveTexture(static_cast<GLenum>(GL_TEXTURE0 + kUvTextureUnit));
    glBindTexture(GL_TEXTURE_2D, uvPlane);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}


@end

