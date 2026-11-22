#version 150

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/post.glsl"

/* RENDERTARGETS: 0 */

in vec2 texcoord;

void main() {
    vec3 col = texture(colortex0, texcoord).rgb;
    col += texture(colortex6, texcoord).rgb * BLOOM_STRENGTH;
    col *= EXPOSURE;
    col = acesFilmic(col);
    col = pow(max(col, vec3(0.0)), vec3(1.0 / 2.2));

    float l = luminance(col);
    col = mix(vec3(l), col, SATURATION);
    col = (col - 0.5) * CONTRAST + 0.5;
    col *= vec3(1.0 + TEMPERATURE * 0.5, 1.0 + TEMPERATURE * 0.08, 1.0 - TEMPERATURE * 0.5);

    vec2 q = texcoord - 0.5;
    col *= 1.0 - VIGNETTE * smoothstep(0.35, 1.1, length(q * vec2(aspectRatio, 1.0)) * 1.6);

    col += (hash12(gl_FragCoord.xy + float(frameCounter % 1000)) - 0.5) / 255.0;
    gl_FragData[0] = vec4(clamp(col, 0.0, 1.0), 1.0);
}
