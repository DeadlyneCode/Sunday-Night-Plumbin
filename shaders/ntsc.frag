#pragma header

#pragma format R8G8B8A8_SRGB

#define NTSC_CRT_GAMMA 2.5
#define NTSC_MONITOR_GAMMA 2.0

#define TWO_PHASE
#define COMPOSITE



#define PI 3.14159265

#if defined(TWO_PHASE)
    #define CHROMA_MOD_FREQ (4.0 * PI / 15.0)
#elif defined(THREE_PHASE)
    #define CHROMA_MOD_FREQ (PI / 3.0)
#endif

#if defined(COMPOSITE)
    #define SATURATION 1.0
    #define BRIGHTNESS 1.0
    #define ARTIFACTING 1.0
    #define FRINGING 1.0
#elif defined(SVIDEO)
    #define SATURATION 1.0
    #define BRIGHTNESS 1.0
    #define ARTIFACTING 0.0
    #define FRINGING 0.0
#endif


uniform int uFrame;
uniform float uInterlace;
uniform float iTime;



#if defined(COMPOSITE) || defined(SVIDEO)
mat3 mix_mat = mat3(
    BRIGHTNESS, FRINGING, FRINGING,
    ARTIFACTING, 2.0 * SATURATION, 0.0,
    ARTIFACTING, 0.0, 2.0 * SATURATION
);
#endif


const mat3 yiq2rgb_mat = mat3(
    1.0, 0.956, 0.6210,
    1.0, -0.2720, -0.6474,
    1.0, -1.1060, 1.7046);

vec3 yiq2rgb(vec3 yiq)
{
    return yiq * yiq2rgb_mat;
}

const mat3 yiq_mat = mat3(
    0.2989, 0.5870, 0.1140,
    0.5959, -0.2744, -0.3216,
    0.2115, -0.5229, 0.3114
);

vec3 rgb2yiq(vec3 col)
{
    return col * yiq_mat;
}


#define TAPS 32
const float luma_filter[TAPS + 1] = float[TAPS + 1](
    -0.000174844,
    -0.000205844,
    -0.000149453,
    -0.000051693,
    0.000000000,
    -0.000066171,
    -0.000245058,
    -0.000432928,
    -0.000472644,
    -0.000252236,
    0.000198929,
    0.000687058,
    0.000944112,
    0.000803467,
    0.000363199,
    0.000013422,
    0.000253402,
    0.001339461,
    0.002932972,
    0.003983485,
    0.003026683,
    -0.001102056,
    -0.008373026,
    -0.016897700,
    -0.022914480,
    -0.021642347,
    -0.008863273,
    0.017271957,
    0.054921920,
    0.098342579,
    0.139044281,
    0.168055832,
    0.178571429);

const float chroma_filter[TAPS + 1] = float[TAPS + 1](
    0.001384762,
    0.001678312,
    0.002021715,
    0.002420562,
    0.002880460,
    0.003406879,
    0.004004985,
    0.004679445,
    0.005434218,
    0.006272332,
    0.007195654,
    0.008204665,
    0.009298238,
    0.010473450,
    0.011725413,
    0.013047155,
    0.014429548,
    0.015861306,
    0.017329037,
    0.018817382,
    0.020309220,
    0.021785952,
    0.023227857,
    0.024614500,
    0.025925203,
    0.027139546,
    0.028237893,
    0.029201910,
    0.030015081,
    0.030663170,
    0.031134640,
    0.031420995,
    0.031517031);

mediump vec4 pass1(mediump vec2 uv)
{
    mediump vec2 fragCoord = uv * openfl_TextureSize;

    mediump vec4 cola = texture2D(bitmap, uv).rgba;
    mediump vec3 yiq = rgb2yiq(cola.rgb);

    #if defined(TWO_PHASE)
        mediump float chroma_phase = PI * (mod(fragCoord.y, 2.0) + float(uFrame));
    #elif defined(THREE_PHASE)
        mediump float chroma_phase = 0.6667 * PI * (mod(fragCoord.y, 3.0) + float(uFrame));
    #endif

    mediump float mod_phase = chroma_phase + fragCoord.x * CHROMA_MOD_FREQ;

    mediump float i_mod = cos(mod_phase);
    mediump float q_mod = sin(mod_phase);

    if(uInterlace == 1.0) {
        yiq.yz *= vec2(i_mod, q_mod); 
        yiq *= mix_mat; 
        yiq.yz *= vec2(i_mod, q_mod);
    }
    return vec4(yiq, cola.a);
}

mediump vec4 fetch_offset(mediump vec2 uv, mediump float offset, mediump float one_x) {
    return pass1(uv + vec2((offset - 0.5) * one_x, 0.0)).xyzw;
}


mediump vec2 curve(mediump vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv *= 1.1;
    
    mediump float uvx2 = uv.x * uv.x;
    mediump float uvy2 = uv.y * uv.y;

    uv.x *= 1.0 + uvy2 / 25.0;
    uv.y *= 1.0 + uvx2 / 16.0;

    uv = (uv / 2.0) + 0.5;
    uv = uv * 0.95 + 0.02;

    return uv;
}

mediump float hash11(mediump float a)
{
    return fract(53.156 * sin(a * 45.45)) - 0.5;
}

mediump float dispnoise(mediump float a)
{
    mediump float a1 = hash11(floor(a)), a2 = hash11(ceil(a));
    return 0.03 * mix(a1, a2, pow(fract(a), 8.));
}

void main()
{
    mediump vec2 uv = openfl_TextureCoordv.xy;
    mediump vec2 fragCoord = uv * openfl_TextureSize;
    mediump vec2 iResolution = openfl_TextureSize;

    uv = curve(uv);


    mediump float bounds = step(0.0, uv.x) * step(uv.x, 1.0) * step(0.0, uv.y) * step(uv.y, 1.0);
    if (bounds == 0.0) {
        gl_FragColor = vec4(0.0);
        return;
    }

    mediump vec3 col;


    col.r = texture2D(bitmap, vec2(uv.x + 0.001, uv.y)).x;
    col.g = texture2D(bitmap, vec2(uv.x, uv.y)).y;
    col.b = texture2D(bitmap, vec2(uv.x - 0.002, uv.y)).z;


    col *= 0.9 + 0.1 * sin(10.0 * iTime + uv.y * 1400.0);
    col *= 1.0 + 0.01 * sin(110.0 * iTime);

    mediump vec4 signal = vec4(0.0);

    mediump float one_x = 1.0 / openfl_TextureSize.x;

 
    signal += fetch_offset(uv, 0.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[0], chroma_filter[0], chroma_filter[0], 1.0);
    signal += fetch_offset(uv, 1.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[1], chroma_filter[1], chroma_filter[1], 1.0);
    signal += fetch_offset(uv, 2.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[2], chroma_filter[2], chroma_filter[2], 1.0);
    signal += fetch_offset(uv, 3.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[3], chroma_filter[3], chroma_filter[3], 1.0);
    signal += fetch_offset(uv, 4.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[4], chroma_filter[4], chroma_filter[4], 1.0);
    signal += fetch_offset(uv, 5.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[5], chroma_filter[5], chroma_filter[5], 1.0);
    signal += fetch_offset(uv, 6.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[6], chroma_filter[6], chroma_filter[6], 1.0);
    signal += fetch_offset(uv, 7.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[7], chroma_filter[7], chroma_filter[7], 1.0);
    signal += fetch_offset(uv, 8.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[8], chroma_filter[8], chroma_filter[8], 1.0);
    signal += fetch_offset(uv, 9.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[9], chroma_filter[9], chroma_filter[9], 1.0);
    signal += fetch_offset(uv, 10.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[10], chroma_filter[10], chroma_filter[10], 1.0);
    signal += fetch_offset(uv, 11.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[11], chroma_filter[11], chroma_filter[11], 1.0);
    signal += fetch_offset(uv, 12.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[12], chroma_filter[12], chroma_filter[12], 1.0);
    signal += fetch_offset(uv, 13.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[13], chroma_filter[13], chroma_filter[13], 1.0);
    signal += fetch_offset(uv, 14.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[14], chroma_filter[14], chroma_filter[14], 1.0);
    signal += fetch_offset(uv, 15.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[15], chroma_filter[15], chroma_filter[15], 1.0);
    signal += fetch_offset(uv, 16.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[16], chroma_filter[16], chroma_filter[16], 1.0);
    signal += fetch_offset(uv, 17.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[17], chroma_filter[17], chroma_filter[17], 1.0);
    signal += fetch_offset(uv, 18.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[18], chroma_filter[18], chroma_filter[18], 1.0);
    signal += fetch_offset(uv, 19.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[19], chroma_filter[19], chroma_filter[19], 1.0);
    signal += fetch_offset(uv, 20.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[20], chroma_filter[20], chroma_filter[20], 1.0);
    signal += fetch_offset(uv, 21.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[21], chroma_filter[21], chroma_filter[21], 1.0);
    signal += fetch_offset(uv, 22.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[22], chroma_filter[22], chroma_filter[22], 1.0);
    signal += fetch_offset(uv, 23.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[23], chroma_filter[23], chroma_filter[23], 1.0);
    signal += fetch_offset(uv, 24.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[24], chroma_filter[24], chroma_filter[24], 1.0);
    signal += fetch_offset(uv, 25.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[25], chroma_filter[25], chroma_filter[25], 1.0);
    signal += fetch_offset(uv, 26.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[26], chroma_filter[26], chroma_filter[26], 1.0);
    signal += fetch_offset(uv, 27.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[27], chroma_filter[27], chroma_filter[27], 1.0);
    signal += fetch_offset(uv, 28.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[28], chroma_filter[28], chroma_filter[28], 1.0);
    signal += fetch_offset(uv, 29.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[29], chroma_filter[29], chroma_filter[29], 1.0);
    signal += fetch_offset(uv, 30.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[30], chroma_filter[30], chroma_filter[30], 1.0);
    signal += fetch_offset(uv, 31.0 - float(TAPS), one_x) * 2.0 * vec4(luma_filter[31], chroma_filter[31], chroma_filter[31], 1.0);

    signal += pass1(uv - vec2(0.5 * one_x, 0.0)) * vec4(luma_filter[TAPS], chroma_filter[TAPS], chroma_filter[TAPS], 1.0);

    mediump vec3 rgb = yiq2rgb(signal.xyz);
    rgb = clamp(rgb, 0.0, 1.0);  
    mediump vec4 color = vec4(pow(rgb, vec3(NTSC_CRT_GAMMA / NTSC_MONITOR_GAMMA)), texture2D(bitmap, uv).a);


    mediump float disp = dispnoise(0.7 * uv.y + mod(iTime, 200.0) * 0.2);
    mediump vec2 curvedCoord = curve(fragCoord.xy / iResolution.xy);
    mediump float barCond = abs(2.05 * curvedCoord.x * iResolution.x - (1.0 - disp) * iResolution.x) - (4.41 / 3.0) * iResolution.y;
    color *= step(barCond, 0.0);  

    gl_FragColor = color;
}