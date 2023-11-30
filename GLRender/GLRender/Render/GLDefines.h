//
//  GLDefines.h
//  GLRender
//
//  Created by yxibng on 2023/11/21.
//

#ifndef GLDefines_h
#define GLDefines_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GLVideoRotation0 = 0,
    GLVideoRotation90 = 90,
    GLVideoRotation180 = 180,
    GLVideoRotation270 = 270
} GLVideoRotation;

typedef enum : NSUInteger {
    //Stretch to fill view bounds
    GLVideoGravityResize,
    //Preserve aspect ratio; fit within view bounds
    GLVideoGravityResizeAspect,
    //Preserve aspect ratio; fill view bounds.
    GLVideoGravityResizeAspectFill,
} GLVideoGravity;

#endif /* GLDefines_h */
