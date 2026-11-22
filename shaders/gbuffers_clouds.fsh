#version 150

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/lighting.glsl"

/* RENDERTARGETS: 0,1,2,3 */

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in vec3 normal;
in vec3 viewPos;
in vec3 worldPos;

void main() {
    vec2 wind = vec2(frameTime * 1.5, frameTime * 0.4);
    vec2 cuv = worldPos.xz * 0.006 + wind * 0.01;
    float n = fbm(cuv * 4.0);
    float alpha = smoothstep(CLOUD_COVER, CLOUD_COVER + 0.28, n);
    if (alpha < 0.02) {
        discard;
    }
    float dayF = worldDayFactor();
    vec3 sunDirW = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
    float self = fbm(cuv * 4.0 + sunDirW.xz * 0.08 + 7.0);
    vec3 col = mix(vec3(0.06, 0.07, 0.10), vec3(1.05, 1.05, 1.10), dayF);
    col *= 0.45 + 0.55 * clamp(sunDirW.y * 0.5 + 0.5, 0.0, 1.0);
    col *= 0.65 + 0.35 * self;

    float dist = length(worldPos - cameraPosition);
    alpha *= clamp(1.0 - (dist - 150.0) / 500.0, 0.0, 1.0);

    vec3 scene = texture(colortex0, texcoord).rgb;
    gl_FragData[0] = vec4(mix(scene, col, alpha), 1.0);
    gl_FragData[1] = vec4(0.0, 1.0, 0.0, 1.0);
    gl_FragData[2] = vec4(encodeNormal(vec3(0.0, 1.0, 0.0)), encodeMat(MAT_CLOUD));
    gl_FragData[3] = vec4(0.0, 0.0, 0.0, 1.0);
}
