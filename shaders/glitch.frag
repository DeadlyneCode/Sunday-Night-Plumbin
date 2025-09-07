#pragma header

uniform float binaryIntensity;
uniform float negativity;

vec4 applyColorTransform(vec4 color) {
    if(color.a == 0.0) return vec4(0.0);
    color.rgb = color.rgb / color.a;
    color = clamp(openfl_ColorOffsetv + color * openfl_ColorMultiplierv, 0.0, 1.0);
    color.rgb *= color.a;
    color.rgb *= openfl_Alphav;
    color.a *= openfl_Alphav;
    return color;
}

void main() {

    #pragma body

    vec2 uv = openfl_TextureCoordv.xy;

    // snapped positions for binary/pixel effect
    float psize = 0.04 * binaryIntensity;
    float psq = 1.0 / psize;

    float px = floor(uv.x * psq + 0.5) * psize;
    float py = floor(uv.y * psq + 0.5) * psize;

    vec4 colSnap = texture2D(bitmap, vec2(px, py));

    /*if(colSnap.a < 0.01) {
        gl_FragColor = colSnap; // fully transparent, skip glitch
        return;
    }*/

    float lum = pow(1.0 - (colSnap.r + colSnap.g + colSnap.b) / 3.0, binaryIntensity);
    lum = max(lum, 0.05); 

    float qsize = max(psize * lum, 0.001);
    float qsq = 1.0 / qsize;

    float qx = floor(uv.x * qsq + 0.5) * qsize;
    float qy = floor(uv.y * qsq + 0.5) * qsize;

    float rx = clamp((px - qx) * lum + uv.x, 0.0, 1.0);
    float ry = clamp((py - qy) * lum + uv.y, 0.0, 1.0);

    vec4 finalColor = applyColorTransform(texture2D(bitmap, vec2(rx, ry)));

    vec4 negativeColor = vec4(1.0 - finalColor.rgb, finalColor.a);
    vec4 outputColor = finalColor;
    if(finalColor.a > 0.01) {
        outputColor = mix(finalColor, vec4(1.0 - finalColor.rgb, finalColor.a), negativity);
    }
    gl_FragColor = outputColor;
}
