//
//  GLRenderView.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import <UIKit/UIKit.h>
#import "GLVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLRenderView : UIView

@property (nonatomic, assign) GLVideoGravity videoGravity;
@property (nonatomic, assign) BOOL mirrored;

- (void)renderVideoFrame:(GLVideoFrame *)videoFrame;

@end

NS_ASSUME_NONNULL_END
