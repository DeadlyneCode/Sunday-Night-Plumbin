#pragma header
	
	#define round(a) floor(a + 0.5)
	#define iResolution vec3(openfl_TextureSize, 0.)
	uniform float iTime;
	#define iChannel0 bitmap
	uniform sampler2D iChannel1;
	uniform sampler2D iChannel2;
	uniform sampler2D iChannel3;
	#define texture flixel_texture2D
	
	// third argument fix
	vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
		vec4 color = texture2D(bitmap, coord, bias);
		if (!hasTransform)
		{
			return color;
		}
		if (color.a == 0.0)
		{
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
		if (!hasColorTransform)
		{
			return color * openfl_Alphav;
		}
		color = vec4(color.rgb / color.a, color.a);
		mat4 colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
		color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
		if (color.a > 0.0)
		{
			return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
		}
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	
	// variables which is empty, they need just to avoid crashing shader
	uniform float iTimeDelta;
	uniform float iFrameRate;
	uniform int iFrame;
	#define iChannelTime float[4](iTime, 0., 0., 0.)
	#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
	uniform vec4 iMouse;
	uniform vec4 iDate;
	
	float nrand(float x, float y) 
	{
		return fract(sin(dot(
			vec2(x, y), vec2(12.9898, 78.233))) * 
			43758.5453); 
	}
	vec4 Blend(vec4 top, vec4 bottom) 
	{
		vec4 result;
		result.a = top.a + bottom.a * (1.0 - top.a);
		result.rgb = (top.rgb * top.aaa + bottom.rgb * bottom.aaa * 
			(vec3(1.0, 1.0, 1.0) - top.aaa)) / result.aaa;
		return result;
	}
	void mainImage( out vec4 fragColor, in vec2 fragCoord )
	{
		vec2 uv = fragCoord.xy / iResolution.xy;
		
		float jitter = nrand(uv.y, iTime / 20.) * 2. - 1.;
		uv.x += jitter * step(0.0, abs(jitter)) * 0.00175;
		
		vec2 texel = 1. / iResolution.xy;
		vec3 duv = texel.xyx * vec3(0.5, 0.5, -0.5);
	
		vec3 blur = texture(iChannel0, uv.xy - duv.xy).rgb;
		blur += texture(iChannel0, uv.xy - duv.zy).rgb;
		blur += texture(iChannel0, uv.xy + duv.zy).rgb;
		blur += texture(iChannel0, uv.xy + duv.xy).rgb;
		blur /= 4.;
		
		float sub = -0.1;
		float hard = 0.3;
	
		float modulo = floor(mod(uv.x / texel.x * 0.25, 3.0));
		vec3 tmp = blur.rgb;
		float is0 = step(modulo, 0.) * step(0., modulo);
		float is1 = step(1., modulo) * step(modulo, 1.);
		tmp -= vec3(0., sub * hard, 
			sub * hard * 2.0) * is0;
		tmp -= vec3(sub * hard, 0., 
			sub * hard) * step(1., modulo) * step(modulo, 1.);
		tmp -= vec3(sub * hard * 2.0, 
			sub * hard, 0.) * (1. - is0) * (1. - is1);
		vec3 col = Blend(vec4(tmp, 0.9), vec4(blur, 1.)).rgb;
		
		float scanline = 
			sin((uv.y - sin(iTime / 400.)) * iResolution.y) * 0.050;
		col.rgb -= scanline;
		fragColor = vec4(col, texture(iChannel0, uv).a);
	}
	
	void main() {
		mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
	}