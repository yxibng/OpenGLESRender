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


@implementation GLShader

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




@end
