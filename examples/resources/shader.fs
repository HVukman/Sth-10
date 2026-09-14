#version 330
in vec2 fragTexCoord;
in vec4 fragColor;
uniform float time;

// Input uniform values
uniform sampler2D texture0;
uniform vec4 colDiffuse;
uniform vec2 resolution;

out vec4 finalColor;


#define MAX_STEPS 196
#define MIN_DIST 0.002
#define NORMAL_SMOOTHNESS 0.1
#define PI 3.14159265359




#define RGB(r,g,b) (vec3(r,g,b) / 255.0)



#define DITHER


float bayer4(vec2 p)
{
    ivec2 i = ivec2(mod(p, 4.0));

    const float m[16] = float[](
         0.0,  8.0,  2.0, 10.0,
        12.0,  4.0, 14.0,  6.0,
         3.0, 11.0,  1.0,  9.0,
        15.0,  7.0, 13.0,  5.0
    );

    return (m[i.y * 4 + i.x] + 0.5) / 16.0;
}





void main() {


    vec3 color = texture(texture0, fragTexCoord).rgb;

    // Convert RGB to grayscale value for palette indexing
    float gray = dot(color, vec3(0.299, 0.587, 0.114));

    vec2 fragCoord = gl_FragCoord.xy;


   // Simple quantized dithering (not using palette)
    float levels = 5.0;
    vec3 ditheredColor = floor(color * levels + bayer4(fragCoord)) / levels;


    vec2 uv = fragCoord / resolution.xy;

    float brightness = 1.0;
    float pos = mod(fragCoord.x, 3.0);

    // Create RGB stripe mask
    float falloff = 0.3;
    vec3 mask = vec3(0.0);
    mask.r = exp(-pow(pos, 2.0) * falloff);
    mask.g = exp(-pow(pos - 1.0, 2.0) * falloff);
    mask.b = exp(-pow(pos - 2.0, 2.0) * falloff);

    // Normalize so total brightness isn't reduced
    mask = mask / max(mask.r + mask.g + mask.b, 0.001);

    float maskStrength = 0.5;
    mask = mix(vec3(1.0), mask, maskStrength);

    // Apply CRT mask to the DITHERED color
    vec3 crtColor = color * mask * brightness;

    // Add scanlines for extra CRT feel
    float scanline = 0.5 + 0.5 * sin(fragCoord.y * 2.0 * 3.14159);
    float scanlineAmount = 0.1;
    crtColor *= (1.0 - scanlineAmount * scanline);


    finalColor = vec4(crtColor, 1.0);


}
