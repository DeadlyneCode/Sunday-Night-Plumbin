// SHADER BY BBPANZU THANK YOU  (also when fnf update????)!!1111
#pragma header

// GAUSSIAN BLUR SETTINGS
uniform float dim;
float directions = 8.0;
float quality = 4;
//float directions = 16;
//float quality = 10;
uniform float size; 

void main(void)
{ 
    vec2 uv = openfl_TextureCoordv.xy ;

    float Pi = 6.28318530718; // Pi*2

    vec4 Color = texture2D( bitmap, uv);

	float aaply = 0.0;

    for(float d=0.0; d<Pi; d+=Pi/directions){
        for(float i=1.0/quality; i<=1.0; i+=1.0/quality){

            float ex = (cos(d)*size*i)/openfl_TextureSize.x;
            float why = (sin(d)*size*i)/openfl_TextureSize.y;
            Color += flixel_texture2D( bitmap, uv+vec2(ex,why));
			aaply += dim;
        }
    }

    Color /= max(aaply - (directions - 1.0), 1);//(dim * quality) * directions - (directions - 1.0);
    vec4 bloom =  (flixel_texture2D( bitmap, uv)/ dim)+Color;

    gl_FragColor = bloom;

}