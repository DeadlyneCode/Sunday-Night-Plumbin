#pragma header

vec2 uv = openfl_TextureCoordv.xy; // This holds the UV coordinates (0 to 1 range)
vec2 fragCoord = uv * openfl_TextureSize; // Convert UV to fragment coordinates
vec2 iResolution = openfl_TextureSize; // Resolution of the texture
uniform float iTime; 
#define iChannel0 bitmap // Define the texture channel
#define texture flixel_texture2D // Alias for the texture function
#define fragColor gl_FragColor // Alias for the fragment color output
#define mainImage main // Alias for the main function
uniform sampler2D distortTexture;

void main() {
    // Get the normalized pixel coordinates (UV)
    vec2 uv = openfl_TextureCoordv.xy;

    // Adjust the UV coordinates by adding a time-dependent offset to create the wave effect
    vec2 distortedUV = uv;
    distortedUV.t -= iTime * 0.05;
    distortedUV.t = mod(distortedUV.t, 1.0);

    // Sample the distortion texture at the adjusted UV coordinates
    vec4 distortion = flixel_texture2D(distortTexture, distortedUV);

    // Extract the distortion offset from the texture
    vec2 offset = distortion.xy - vec2(0.5, 0.5);
    offset *= 2.0; // Scale the offset for more intensity
    offset *= 0.009; // Control the overall intensity of the distortion

    // Reduce the distortion effect towards the top of the screen
    offset *= pow(uv.t, 1.4); // Control how high up the screen the effect is applied

    // Apply the offset to the original UV coordinates
    vec2 finalUV = uv + offset;

    // Sample the original texture using the modified UV coordinates
    gl_FragColor = flixel_texture2D(bitmap, finalUV);
}
