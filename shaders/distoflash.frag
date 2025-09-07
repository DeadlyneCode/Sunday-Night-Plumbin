#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

uniform float dim;
uniform float Size;

const float Soft = 0.001;
const float Threshold = 0.3;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = (uv - 0.5) * (1.0 - Size) + 0.5;

    vec4 tx = texture(iChannel0, uv);
    float f = Soft / 2.0;
    float a = Threshold - f;
    float b = Threshold + f;

    float l = (tx.r + tx.g + tx.b) / 3.0;
    float v = smoothstep(a, b, l);

    vec4 effectColor = vec4(vec3(v), 1.0);
    fragColor = mix(tx, effectColor, clamp(dim, 0.0, 1.0));
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}
