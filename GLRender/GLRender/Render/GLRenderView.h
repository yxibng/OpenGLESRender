//
//  GLRenderView.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import <UIKit/UIKit.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

//AVLayerVideoGravityResize, AVLayerVideoGravityResizeAspect and AVLayerVideoGravityResizeAspectFill. AVLayerVideoGravityResizeAspect

typedef enum : NSUInteger {
    //Stretch to fill view bounds
    GLVideoGravityResize,
    //Preserve aspect ratio; fit within view bounds
    GLVideoGravityResizeAspect,
    //Preserve aspect ratio; fill view bounds.
    GLVideoGravityResizeAspectFill,
} GLVideoGravity;





@interface GLRenderView : GLKView

@property (nonatomic, assign) GLVideoGravity videoGravity;
@property (nonatomic, assign) BOOL mirrored;

@end

NS_ASSUME_NONNULL_END
