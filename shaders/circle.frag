#pragma header

uniform vec2 uResolution;
uniform vec2 uCenter;
uniform float uRadius;
#define iChannel0 bitmap

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 pixelPos = uv * uResolution;

    float dist = distance(pixelPos, uCenter);

    if (dist <= uRadius) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        gl_FragColor = flixel_texture2D(bitmap, uv);
    }
}
