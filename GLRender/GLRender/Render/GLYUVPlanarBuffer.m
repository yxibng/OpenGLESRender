//
//  GLYUVPlanarBuffer.m
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

#import "GLYUVPlanarBuffer.h"

@interface GLYUVPlanarBuffer ()
@property (nonatomic) int width;
@property (nonatomic) int height;

@property(nonatomic) const uint8_t *dataY;
@property(nonatomic) int strideY;

@property(nonatomic) const uint8_t *dataU;
@property(nonatomic) int strideU;
@property(nonatomic) const uint8_t *dataV;
@property(nonatomic) int strideV;

@property(nonatomic) const uint8_t *dataUV;
@property(nonatomic) int strideUV;

@property (nonatomic) GLYUVType yuvType;
@end




@implementation GLYUVPlanarBuffer

- (void)dealloc {
    if (_dataY) free((void *)_dataY);
    if (_dataU) free((void *)_dataU);
    if (_dataV) free((void *)_dataV);
    if (_dataUV) free((void *)_dataUV);
}

- (nonnull instancetype)initWithWidth:(int)width height:(int)height dataY:(nonnull const uint8_t *)dataY dataUV:(nonnull const uint8_t *)dataUV strideY:(int)strideY strideUV:(int)strideUV {
    
    if (self = [super init]) {
        
        _yuvType = GLYUVTypeNV12;
        _width = width;
        _height = height;
        _strideY = strideY;
        _strideUV = strideUV;
        
        _dataY = calloc(1, strideY * height);
        memcpy((void *)_dataY, (void *)dataY, strideY * height);
        _dataUV = calloc(1, strideUV * height / 2);
        memcpy((void *)_dataUV, (void *)dataUV, strideUV * height / 2);
    }
    return self;
}

- (nonnull instancetype)initWithWidth:(int)width height:(int)height dataY:(nonnull const uint8_t *)dataY dataU:(nonnull const uint8_t *)dataU dataV:(nonnull const uint8_t *)dataV strideY:(int)strideY strideU:(int)strideU strideV:(int)strideV {
    if (self = [super init]) {
        _yuvType = GLYUVTypeI420;
        _width = width;
        _height = height;
        _strideY = strideY;
        _strideU = strideU;
        _strideV = strideV;
        
        _dataY = calloc(1, strideY * height);
        memcpy((void *)_dataY, (void *)dataY, strideY * height);
        _dataU = calloc(1, strideU * height / 2);
        memcpy((void *)_dataU, (void *)dataU, strideU * height / 2);
        _dataV = calloc(1, strideV * height / 2);
        memcpy((void *)_dataV, (void *)dataV, strideV * height / 2);
    }
    return self;
}

@end
