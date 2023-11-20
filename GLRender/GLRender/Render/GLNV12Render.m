//
//  GLNV12Render.m
//  GLRender
//
//  Created by yxibng on 2023/11/20.
//

#import "GLNV12Render.h"


typedef struct  {
    GLKVector2 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;


// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-1.0, 1.0}, {0, 1}}, //左上角
    {{1.0, 1.0}, {1, 1}}, //右上角
    {{-1.0, -1.0}, {0, 1}}, //左下角
    {{1.0, -1.0}, {1, 0}}, //右下角
};

@implementation GLNV12Render

@end
