#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

vec2 curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0; // Retrecir ecran
    uv *= 1.1;
    
    float uvx2 = uv.x * uv.x;
    float uvy2 = uv.y * uv.y;

    uv.x *= 1.0 + uvy2 / 25.0;
    uv.y *= 1.0 + uvx2 / 16.0;

    uv = (uv / 2.0) + 0.5;
    uv = uv * 0.95 + 0.02;

    return uv;
}

float hash11(float a)
{
    return fract(53.156*sin(a*45.45))-.5;
}

float dispnoise(float a)
{
    float a1 = hash11(floor(a)), a2 = hash11(ceil(a));
    return .03 * mix(a1, a2, pow(fract(a), 8.));
}

void mainImage() {
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = curve(uv);

    vec3 col;

    // Chromatic aberration
    col.r = texture(iChannel0, vec2(uv.x + 0.001, uv.y)).x;
    col.g = texture(iChannel0, vec2(uv.x, uv.y)).y;
    col.b = texture(iChannel0, vec2(uv.x - 0.002, uv.y)).z;

    // Ensure colors are within screen bounds
    col *= step(0.0, uv.x) * step(0.0, uv.y);
    col *= 1.0 - step(1.0, uv.x) * 1.0 - step(1.0, uv.y);

    // Additional effects
    col *= 0.9 + 0.1 * sin(10.0 * iTime + uv.y * 1400.0);
    col *= 1.0 + 0.01 * sin(110.0 * iTime);

    vec4 color = vec4(col, 0.8);

    // Apply black bars on sides with distortion
    float disp = dispnoise(0.7 * uv.y + mod(iTime, 200.0) * 0.2);
    vec2 curvedCoord = curve(fragCoord.xy / iResolution.xy);
    if (abs(2.05 * curvedCoord.x * iResolution.x - (1.0 - disp) * iResolution.x) > (4.41 / 3) * iResolution.y) {
        color = vec4(0);
    }

    fragColor = color;
}
