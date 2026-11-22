#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/distort.glsl"
#include "/include/lighting.glsl"
#include "/include/volumetrics.glsl"

/* RENDERTARGETS: 0 */

varying vec2 texcoord;

void main() {
    vec3 col = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;
    if (depth >= 1.0) {
        gl_FragData[0] = vec4(col, 1.0);
        return;
    }
    vec3 wp = screenToWorld(texcoord, depth);
    float dist = length(wp - cameraPosition);
    vec3 insc = vec3(0.0);
    float trans = 1.0;
    volumetrics(texcoord, wp, dist, insc, trans);
    gl_FragData[0] = vec4(col * trans + insc, 1.0);
}
