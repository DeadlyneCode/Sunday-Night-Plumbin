#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;

    vec4 textureColor = texture(iChannel0, uv);

    if(textureColor.a < 0.1){
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0);

    float average = (textureColor.r + textureColor.g + textureColor.b) / 3.5;

    if(average <= 0.5) {
        fragColor = vec4(black.rgb, textureColor.a);
    } else {
        fragColor = vec4(white.rgb, textureColor.a);
    }
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
