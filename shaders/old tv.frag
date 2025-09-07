#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

vec2 crt_coords(vec2 uv, float bend) {
    uv = (uv - 0.5) * 2.3;
    uv.x *= 1.0 + pow(abs(uv.y) / bend, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x) / bend, 2.0);
    return uv / 2.5 + 0.5;
}

void mainImage() {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 crt_uv = crt_coords(uv, 4.0);
    
    vec4 col = texture(iChannel0, crt_uv);
    
    fragColor = col;
}
