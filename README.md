# OpenGLESRender

注意事项：

CVOpenGLESTextureCacheCreateTextureFromImage() 创建的 Texture 的坐标有问题，需要翻转。
CVPixelBuffers have a top left origin and OpenGL has a bottom left origin.


正常情况

```
vertex
(-1, 1)  | (1, 1)
----------------
(-1, -1) | (1, -1)

texture
(0,1) | (1,1)
---------------
(0,0) | (1,0)
```


CVPixelBuffer应该是

```
vertex
(-1, 1)  | (1, 1)
----------------
(-1, -1) | (1, -1)

texture
(0,0) | (1,0)
---------------
(0,1) | (1,1)
```


