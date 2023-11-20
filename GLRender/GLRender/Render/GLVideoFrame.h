//
//  GLVideoFrame.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GLRotation0,
    GLRotation90,
    GLRotation180,
    GLRotation270
} GLRotation;


NS_ASSUME_NONNULL_BEGIN

@interface GLVideoFrame : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) GLRotation rotation;




@end

NS_ASSUME_NONNULL_END
