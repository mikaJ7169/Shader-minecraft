#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/lighting.glsl"
#include "/include/ssr.glsl"
#include "/include/sky.glsl"

/* RENDERTARGETS: 0 */

varying vec2 texcoord;

void main() {
    vec3 col = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;
    if (depth >= 1.0) {
        gl_FragData[0] = vec4(col, 1.0);
        return;
    }
    vec4 gb2 = texture2D(colortex2, texcoord);
    vec4 gb3 = texture2D(colortex3, texcoord);
    vec3 data5 = texture2D(colortex5, texcoord).rgb;
    float mat = decodeMat(gb2.a);
    float smooth = gb3.r;
    float metal = gb3.g;
    if (smooth < 0.04 && abs(mat - MAT_WATER) > 0.5) {
        gl_FragData[0] = vec4(col, 1.0);
        return;
    }
    vec3 n = normalize(decodeNormal(gb2.rgb));
    vec3 wp = screenToWorld(texcoord, depth);
    vec3 v = normalize(cameraPosition - wp);
    vec3 vp = screenToView(texcoord, depth);
    vec3 nView = normalize(mat3(gbufferModelView) * n);
    vec3 rView = reflect(normalize(vp), nView);

    float hit = 0.0;
    vec3 refl = ssrTrace(texcoord, vp, rView, hit);
    float dayF = worldDayFactor();
    if (hit < 0.5) {
        vec3 rW = normalize(viewToWorldDir(rView));
        refl = skyColorAt(rW, normalize(sunPosition), dayF) * (0.35 + 0.65 * dayF);
    }

    vec3 albedo = pow(max(texture2D(colortex4, texcoord).rgb, vec3(0.0)), vec3(2.2));
    vec3 f0 = mix(vec3(0.04), albedo, metal);
    float rough = clamp(1.0 - smooth, 0.03, 1.0);
    vec3 sunDirW = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
    float ndl = max(dot(n, sunDirW), 0.0);
    vec3 F = fresnelSchlick(max(dot(n, v), 0.0), f0);
    vec3 lightCol = sunLightColor();
    float strength = abs(mat - MAT_WATER) < 0.5 ? 1.0 : smooth * 0.8;

    col += refl * F * strength;
    col += specularGGX(n, v, sunDirW, f0, rough) * lightCol * ndl * clamp(data5.g, 0.0, 1.0) * 4.0;
    gl_FragData[0] = vec4(col, 1.0);
}
