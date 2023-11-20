//
//  GLYUVPlanarBuffer.h
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GLYUVTypeNV12,
    GLYUVTypeI420
} GLYUVType;


@interface GLYUVPlanarBuffer : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;

@property(nonatomic, readonly) const uint8_t *dataY;
@property(nonatomic, readonly) int strideY;

@property(nonatomic, readonly) const uint8_t *dataU;
@property(nonatomic, readonly) int strideU;
@property(nonatomic, readonly) const uint8_t *dataV;
@property(nonatomic, readonly) int strideV;

@property(nonatomic, readonly) const uint8_t *dataUV;
@property(nonatomic, readonly) int strideUV;

@property (nonatomic, readonly) GLYUVType yuvType;

//for I420
- (instancetype)initWithWidth:(int)width
                       height:(int)height
                        dataY:(const uint8_t *)dataY
                        dataU:(const uint8_t *)dataU
                        dataV:(const uint8_t *)dataV
                      strideY:(int)strideY
                      strideU:(int)strideU
                      strideV:(int)strideV;

//for NV12
- (instancetype)initWithWidth:(int)width
                       height:(int)height
                        dataY:(const uint8_t *)dataY
                        dataUV:(const uint8_t *)dataUV
                      strideY:(int)strideY
                      strideUV:(int)strideUV;

@end

NS_ASSUME_NONNULL_END
