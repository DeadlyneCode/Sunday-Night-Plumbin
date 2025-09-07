#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

const float PIXEL_FACTOR = 20000000.0; // Lower num - bigger pixels
const float COLOR_FACTOR = 5.0;   // Higher num - higher colors quality

void mainImage()
{                  
    // Reduce pixels            
        vec4 baseTexture = flixel_texture2D(bitmap, openfl_TextureCoordv);  
    vec2 size = PIXEL_FACTOR * iResolution.xy/iResolution.x;
    vec2 uv = floor( fragCoord/iResolution.xy * size) / size;   
                 
    vec3 col = texture(iChannel0, uv).xyz;     
    
    // Reduce colors
    col = floor(col * COLOR_FACTOR) / COLOR_FACTOR;  

   
    // Output to screen
    fragColor = vec4(col,1.)*baseTexture;
}