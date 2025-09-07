#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

#define MAX_POWER -0.2 // negative : anti fish eye. positive = fisheye

vec4 sampleTexture(vec2 coord) {
    return texture(iChannel0, coord);
}

void mainImage() {
    // Super-sampling anti-aliasing (SSAA) with 9 samples and Gaussian weights
    vec2 offsets[9] = vec2[](
        vec2(-1.0, -1.0), vec2( 0.0, -1.0), vec2( 1.0, -1.0),
        vec2(-1.0,  0.0), vec2( 0.0,  0.0), vec2( 1.0,  0.0),
        vec2(-1.0,  1.0), vec2( 0.0,  1.0), vec2( 1.0,  1.0)
    );
    
    float weights[9] = float[](
        0.0625, 0.125, 0.0625,
        0.125,  0.25,  0.125,
        0.0625, 0.125, 0.0625
    );
    
    vec4 color = vec4(0.0);
    for(int i = 0; i < 9; i++) {
        vec2 uvOffset = offsets[i] / iResolution.xy;
        vec2 sampleCoord = fragCoord + uvOffset;
        vec2 uv = sampleCoord.xy / iResolution.xy;
        vec2 ndcPos = uv * 1.8 - 0.9;

        float aspect = iResolution.x / iResolution.y;
        float u_angle = -1;
        float eye_angle = abs(u_angle);
        float half_angle = eye_angle / 2.0;
        float half_dist = tan(half_angle);

        vec2 vp_scale = vec2(aspect, 1.0);
        vec2 P = ndcPos * vp_scale;
        float vp_dia = length(vp_scale);
        float rel_dist = length(P) / vp_dia;
        vec2 rel_P = normalize(P) / normalize(vp_scale);

        vec2 pos_prj = ndcPos;
        if (u_angle > 0.0) {
            float beta = rel_dist * half_angle;
            pos_prj = rel_P * tan(beta) / half_dist;
        } else if (u_angle < 0.0) {
            float beta = atan(rel_dist * half_dist);
            pos_prj = rel_P * beta / half_angle;
        }

        vec2 uv_prj = pos_prj * 0.5 + 0.5;
        vec2 rangeCheck = step(vec2(0.0), uv_prj) * step(uv_prj, vec2(1.0));   
        if (rangeCheck.x * rangeCheck.y < 0.5) {
            color += vec4(1.0, 1.0, 1.0, 1.0) * weights[i];
        } else {
            vec4 texColor = sampleTexture(uv_prj.st);
            color += vec4(texColor.rgb, 1.0) * weights[i];
        }
    }
    
    fragColor = color;
}
