#pragma header

const float amount = 1.0;

uniform float dim;
uniform float Size;

float directions = 16.0;
float quality = 8.0;

void main(void) {
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 color = texture2D(bitmap, uv);

    for (float d = 0.0; d < 6.28318530718; d += 6.28318530718 / directions) {
        for (float i = 1.0 / quality; i <= 1.0; i += 1.0 / quality) {

            float offsetX = (cos(d) * Size * i) / openfl_TextureSize.x;
            float offsetY = (sin(d) * Size * i) / openfl_TextureSize.y;

            color += texture2D(bitmap, uv + vec2(offsetX, offsetY));
        }
    }

    color /= (dim * quality) * directions - 15.0;

    vec4 bloom = (texture2D(bitmap, uv) / dim) + color;

    gl_FragColor = bloom;
}
