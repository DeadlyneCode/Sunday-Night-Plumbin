#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    vec2 uv = fragCoord/iResolution.xy;

   // Set the output pixel the same as the input pixel from Britney's video.
    fragColor = texture(iChannel0, uv);
    
    // Alpha shouldn't matter.
    float colVal = fragColor.r + fragColor.g + fragColor.b;
    colVal /= 3.;
        
    if(colVal > 0.5){
        colVal = 1.;
    } else{
        colVal = 0.;
    }
    
    fragColor = vec4(colVal, colVal, colVal, 1);

}

