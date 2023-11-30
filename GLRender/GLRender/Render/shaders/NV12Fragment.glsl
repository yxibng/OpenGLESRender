// Fragment shader converts YUV values from input textures into a final RGB
// pixel. The conversion formula is from http://www.fourcc.org/fccyvrgb.php.

precision mediump float;
varying vec2 v_texcoord;
uniform lowp sampler2D s_textureY;
uniform lowp sampler2D s_textureUV;

void main() {
    
    if (v_texcoord.x < 0.0 || v_texcoord.x > 1.0 ||
        v_texcoord.y < 0.0 || v_texcoord.y > 1.0) {
        discard;
    }
    
    mediump float y;
    mediump vec2 uv;
    y = texture2D(s_textureY, v_texcoord).r;
    uv = texture2D(s_textureUV, v_texcoord).ra - vec2(0.5, 0.5);
    gl_FragColor = vec4(y + 1.403 * uv.y,
                        y - 0.344 * uv.x - 0.714 * uv.y,
                        y + 1.770 * uv.x,
                        1.0);
}
