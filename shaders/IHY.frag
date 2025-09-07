#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float NoiseSeed;
float randomFloat() {
    NoiseSeed = sin(NoiseSeed) * 84522.13219145687;
    return fract(NoiseSeed);
}

float SCurve(float value, float amount, float correction) {
    float curve = 1.0;

    if (value < 0.5) {
        curve = pow(value, amount) * pow(2.0, amount) * 0.5;
    } else {
        curve = 1.0 - pow(1.0 - value, amount) * pow(2.0, amount) * 0.5;
    }

    return pow(curve, correction);
}

// ACES tonemapping
vec3 ACESFilm(vec3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return (x * (a * x + b)) / (x * (c * x + d) + e);
}

// Chromatic Aberration
vec3 chromaticAbberation(sampler2D tex, vec2 uv, float amount) {
    float aberrationAmount = amount / 10.0;
    vec2 distFromCenter = uv - 0.5;

    // Stronger aberration near the edges by raising to power 3
    vec2 aberrated = aberrationAmount * pow(distFromCenter, vec2(3.0, 3.0));
    
    vec3 color = vec3(0.0);
    
    for (int i = 1; i <= 8; i++) {
        float weight = 1.0 / pow(2.0, float(i));
        color.r += texture(tex, uv - float(i) * aberrated).r * weight;
        color.b += texture(tex, uv + float(i) * aberrated).b * weight;
    }
    
    color.g = texture(tex, uv).g * 0.9961; // 0.9961 = weight(1)+weight(2)+...+weight(8);
    return color;
}

// Film grain
vec3 filmGrain() {
    return vec3(0.9 + randomFloat() * 0.15);
}

// Sigmoid Contrast
vec3 contrast(vec3 color) {
    return vec3(SCurve(color.r, 1.5, 1),
                SCurve(color.g, 1.6, 1),
                SCurve(color.b, 1.5, 1));
}

// Margins
vec3 margins(vec3 color, vec2 uv, float marginSize) {
    if (uv.y < marginSize || uv.y > 1.0 - marginSize) {
        return vec3(0.0);
    } else {
        return color;
    }
}

void mainImage() {
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec4 texColor = texture(iChannel0, uv);
    vec3 color = texColor.rgb; // Read the RGB from the texture

    // Chromatic Aberration
    color = chromaticAbberation(iChannel0, uv, 0.15);

    // Film grain
    color *= filmGrain();

    // Contrast
    color = contrast(color) * 0.9;

    // Preserve alpha from the input texture
    float alpha = texColor.a;

    // Output the final color with transparency
    fragColor = vec4(color, alpha);
}
