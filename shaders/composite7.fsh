#version 150

#include "/include/settings.glsl"
#include "/include/common.glsl"

/* RENDERTARGETS: 7 */

in vec2 texcoord;

void main() {
    vec2 px = 1.0 / vec2(viewWidth, viewHeight);
    vec2 o1 = px * 1.3846153846;
    vec2 o2 = px * 3.2307692308;
    vec3 s = texture(colortex6, texcoord).rgb * 0.2270270270;
    s += (texture(colortex6, texcoord + o1).rgb + texture(colortex6, texcoord - o1).rgb) * 0.3162162162;
    s += (texture(colortex6, texcoord + o2).rgb + texture(colortex6, texcoord - o2).rgb) * 0.0702702703;
    gl_FragData[0] = vec4(s, 1.0);
}
