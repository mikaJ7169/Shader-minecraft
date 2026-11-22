#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/textures.glsl"
#include "/include/noise.glsl"
#include "/include/water.glsl"

/* RENDERTARGETS: 0,1,2,3,4 */

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;

void main() {
    vec4 tex = texture2D(gtexture, texcoord);
    float sceneDepth = linearizeDepth(texture2D(depthtex0, texcoord).r);
    float waterDepth = linearizeDepth(gl_FragCoord.z);
    float diff = max(sceneDepth - waterDepth, 0.0);

    float dist = length(worldPos - cameraPosition);
    vec3 n = calcWaterNormal(worldPos, frameTime, dist);
    vec3 nView = mat3(gbufferModelView) * n;

    vec2 off = nView.xy * 0.035 * clamp(diff, 0.0, 3.0);
    vec2 ruv = clamp(texcoord - off, 0.002, 0.998);
    vec3 refr = texture2D(colortex0, ruv).rgb;

    float foam = smoothstep(0.35, 0.05, diff) * (0.6 + 0.4 * snoise2(worldPos.xz * 3.0 + frameTime * 2.0));
    vec3 waterTint = tex.rgb * glcolor.rgb;

    gl_FragData[0] = vec4(refr, 1.0);
    gl_FragData[1] = vec4(lmcoord, diff, foam);
    gl_FragData[2] = vec4(encodeNormal(n), encodeMat(MAT_WATER));
    gl_FragData[3] = vec4(0.96, 0.0, 0.0, 1.0);
    gl_FragData[4] = vec4(waterTint, 1.0);
}
