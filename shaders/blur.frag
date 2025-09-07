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
	vec2 uv = fragCoord / iResolution.xy;
	
	float lod = (5.0 + 5.0*sin( iTime ))*step( uv.x, 0.5 );
	
	vec3 col = texture( iChannel0, vec2(uv.x,1.0-uv.y), lod ).xyz;
	
	fragColor = vec4( col, 1.0 );
}