#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// Uniforms
uniform vec4 u_chromaColor; // The color to make transparent (RGBA normalized)
uniform float u_tolerance;  // Tolerance for matching the chroma key color

void mainImage() {
    // Compute UV coordinates for the texture
    vec2 uv = fragCoord / iResolution.xy;

    // Prevent sampling out-of-bounds for the last column
    if (fragCoord.x >= iResolution.x - 1.0) {
        uv.x = (iResolution.x - 50) / iResolution.x; // Offset to the second-to-last pixel
    }

    // Fetch the texture color from the adjusted UV
    vec4 texColor = texture(iChannel0, uv);

    // Calculate the difference between the texture color and the chroma key color
    float diff = distance(texColor.rgb, u_chromaColor.rgb);

    // If the difference is within tolerance, make the pixel transparent
    if (diff < u_tolerance) {
        fragColor = vec4(texColor.rgb, 0.0); // Fully transparent
    } else {
        fragColor = texColor; // Preserve the original color
    }
}