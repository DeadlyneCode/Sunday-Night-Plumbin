#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    // Original shader code (colorization)
    vec4 baseTexture1 = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec2 p = (fragCoord - 0.5 * iResolution.xy) / iResolution.y; // set center to the middle of the screen

    // Change values here --------------------------------------------------------------
    float red1 = 1.0;    // 0.0 <> 1.0
    float green1 = 0.0;  // 0.0 <> 1.0
    float blue1 = 0.0;   // 0.0 <> 1.0
    // ---------------------------------------------------------------------------------

    vec3 col1 = vec3(red1, green1, blue1); // colorized screen (red)

    // New shader code (color reduction)
    vec4 baseTexture2 = flixel_texture2D(bitmap, openfl_TextureCoordv);
    const float COLOR_FACTOR = 3.5; // Higher num - higher colors quality

    vec3 col2 = texture(iChannel0, uv).xyz;

    // Reduce colors
    col2 = floor(col2 * COLOR_FACTOR) / COLOR_FACTOR;

    // Output to screen
    fragColor = vec4(col1, 1.0) * vec4(col2, 1.0) * baseTexture1 * baseTexture2;
}
