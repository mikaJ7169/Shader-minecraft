#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/textures.glsl"

/* RENDERTARGETS: 6 */

varying vec2 texcoord;

void main() {
    vec3 c = texture2D(colortex0, texcoord).rgb;
    float l = luminance(c);
    float w = smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD + 0.8, l);
    gl_FragData[0] = vec4(c * w, 1.0);
}
