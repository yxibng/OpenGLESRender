//
//  GLRenderView.m
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import "GLRenderView.h"
#import "GLNV12Render.h"
@import GLKit;

@interface GLRenderView ()<GLKViewDelegate>

@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) GLNV12Render *nv12Render;

@property (nonatomic, strong) GLVideoFrame *videoFrame;


@end


@implementation GLRenderView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIApplicationState appState =
    [UIApplication sharedApplication].applicationState;
    if (appState == UIApplicationStateActive) {
        [self teardownGL];
    }
    [self ensureGLContext];
    if (_glContext && [EAGLContext currentContext] == _glContext) {
        [EAGLContext setCurrentContext:nil];
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (![self configure]) return nil;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if (![self configure]) return nil;
    }
    return self;
}


- (BOOL)configure {
    
    EAGLContext *glContext =
      [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!glContext) {
      glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    if (!glContext) {
      NSLog(@"Failed to create EAGLContext");
      return NO;
    }
    
    // GLKView manages a framebuffer for us.
    _glkView = [[GLKView alloc] initWithFrame:CGRectZero
                                      context:_glContext];
    _glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    _glkView.drawableDepthFormat = GLKViewDrawableDepthFormatNone;
    _glkView.drawableStencilFormat = GLKViewDrawableStencilFormatNone;
    _glkView.drawableMultisample = GLKViewDrawableMultisampleNone;
    _glkView.delegate = self;
    _glkView.layer.masksToBounds = YES;
    _glkView.enableSetNeedsDisplay = NO;
    [self addSubview:_glkView];
    _glkView.frame = self.bounds;
    _glkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Listen to application state in order to clean up OpenGL before app goes
    // away.
    NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(willResignActive)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(didBecomeActive)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    
    return YES;
    
}


- (void)setupGL {
  [self ensureGLContext];
  glDisable(GL_DITHER);
}

- (void)teardownGL {
  [_glkView deleteDrawable];
  [self ensureGLContext];
}

- (void)ensureGLContext {
  NSAssert(_glContext, @"context shouldn't be nil");
    if ([EAGLContext currentContext] != _glContext) {
        [EAGLContext setCurrentContext:_glContext];
    }
}

#pragma mark -
- (void)didBecomeActive {
  [self setupGL];
}

- (void)willResignActive {
  [self teardownGL];
}




#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    GLVideoFrame *videoFrame = self.videoFrame;
    if (!videoFrame) return;
    
    
    
    
    
    
    
    
    
    
    
    
}

#pragma mark -

- (void)renderVideoFrame:(GLVideoFrame *)videoFrame {
    self.videoFrame = videoFrame;
    // Only call -[GLKView display] if the drawable size is
    // non-empty. Calling display will make the GLKView setup its
    // render buffer if necessary, but that will fail with error
    // GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT if size is empty.
    if (self.bounds.size.width > 0 && self.bounds.size.height > 0) {
      [_glkView display];
    }
}
@end
