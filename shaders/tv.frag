#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.95 + 0.0275;
	return uv;
}

void mainImage()
{
    //Curve
    vec2 uv = fragCoord.xy / iResolution.xy;
	uv = curve( uv );
    
    vec3 col;

    // Chromatic
    col.r = texture(iChannel0,vec2(uv.x+0.001,uv.y)).x;
    col.g = texture(iChannel0,vec2(uv.x+0.000,uv.y)).y;
    col.b = texture(iChannel0,vec2(uv.x-0.002,uv.y)).z;

    col *= step(0.0, uv.x) * step(0.0, uv.y); //DEFO DE GAUCHE
    col *= 1.0 - step(1.0, uv.x) * 1.0 - step(1.0, uv.y);

    //col *= 0.8 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y); // OMBRE
    col *= vec3(1.0,1.0,1.0);

    col *= 0.9+0.1*sin(10.0*iTime+uv.y*1400.0); // LINE DE MERDE

    col *= 1.0+0.01*sin(110.0*iTime);

    fragColor = vec4(col,0.8);
}