#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/sky.glsl"

/* RENDERTARGETS: 0,2,3 */

varying vec2 texcoord;

void main() {
    vec3 ndc = vec3(texcoord * 2.0 - 1.0, gl_FragCoord.z * 2.0 - 1.0);
    vec3 view = projectAndDivide(gbufferProjectionInverse, ndc);
    vec3 dir = normalize(viewToWorldDir(view));
    float dayF = worldDayFactor();
    float nightF = 1.0 - dayF;
    vec3 sunDir = normalize(sunPosition);
    vec3 moonDir = normalize(moonPosition);

    vec3 col = skyColorAt(dir, sunDir, dayF);
    col += starLayer(dir, nightF * STAR_BRIGHTNESS);
    col += moonLayer(dir, moonDir, nightF);
    col += vec3(1.0, 0.97, 0.85) * smoothstep(0.99955, 0.99985, dot(dir, sunDir)) * 30.0 * dayF;

    gl_FragData[0] = vec4(col, 1.0);
    gl_FragData[1] = vec4(encodeNormal(-dir), encodeMat(MAT_SKY));
    gl_FragData[2] = vec4(0.0, 0.0, smoothstep(0.9993, 0.9999, dot(dir, sunDir)) * 6.0, 1.0);
}
