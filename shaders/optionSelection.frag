#pragma header
uniform float time = 0;

float bound(float v1, float v2, float v3) {
    if (v1 < v2) return v2;
    if (v1 > v3) return v3;
    return v1;
}
void main() {
    gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

    float mul = 3.5 / openfl_TextureSize.x * openfl_TextureSize.y;
    float d = pow(mod(abs(time - (openfl_TextureCoordv.x + ((openfl_TextureCoordv.y) * mul))), 1.0), 2.0);
    if (d > 0.5)
        d = 1.0 - d;
    float dist = bound(d, 0.0, mul) / mul;
    gl_FragColor *= dist;
}