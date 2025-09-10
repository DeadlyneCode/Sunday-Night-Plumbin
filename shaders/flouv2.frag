#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform float Size; // BLUR SIZE (Radius)
        
void mainImage()
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS
    float Directions = 16.0; 
    float Quality    = 3;   // make it an integer for stability
   
    vec2 Radius = Size / iResolution.xy;
    vec2 uv = fragCoord / iResolution.xy;
    
    vec4 sum = vec4(0.0);
    float count = 0.0;

    // Always add center pixel once
    sum += texture(iChannel0, uv);
    count += 1.0;

    // Blur calculations
    for(float d = 0.0; d < Pi; d += Pi / Directions)
    {
        for(float j = 1.0; j <= Quality; j += 1.0)
        {
            float scale = j / Quality; // normalized step [0..1]
            vec2 offset = vec2(cos(d), sin(d)) * Radius * scale;
            sum += texture(iChannel0, uv + offset);
            count += 1.0;
        }
    }

    // Average properly
    fragColor = sum / count;
}
