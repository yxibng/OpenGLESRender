attribute vec2 position;
attribute vec2 texcoord;
varying vec2 v_texcoord;
uniform vec2 textureScale;
uniform int rotation;

void main() {
    gl_Position = vec4(position.x, position.y, 0.0, 1.0);
    
    if (rotation == 0 || rotation == 180) {
        v_texcoord = textureScale * (texcoord - 0.5) + 0.5;
    } else if ( rotation == 90) {
        
    } else if (rotation == 270) {
        
    }
}
