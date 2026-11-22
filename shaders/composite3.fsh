#version 150

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/lighting.glsl"

/* RENDERTARGETS: 0 */

in vec2 texcoord;

void main() {
    vec3 col = texture(colortex0, texcoord).rgb;
    float depth = texture(depthtex0, texcoord).r;
    if (depth >= 1.0) {
        gl_FragData[0] = vec4(col, 1.0);
        return;
    }
    vec4 gb1 = texture(colortex1, texcoord);
    vec4 gb2 = texture(colortex2, texcoord);
    vec4 gb3 = texture(colortex3, texcoord);
    vec3 data5 = texture(colortex5, texcoord).rgb;
    float mat = decodeMat(gb2.a);
    vec3 n = normalize(decodeNormal(gb2.rgb));
    vec2 lm = gb1.rg;
    float ssao = clamp(data5.r, 0.0, 1.0);
    float shadow = clamp(data5.g, 0.0, 1.0);
    float emiss = gb3.b;
    float dayF = worldDayFactor();
    vec3 sunDirW = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
    vec3 lightCol = sunLightColor();
    float ndl = max(dot(n, sunDirW), 0.0);

    vec3 skyAmb = mix(vec3(0.025, 0.035, 0.075), vec3(0.30, 0.40, 0.62), dayF) * AMBIENT_INTENSITY;
    vec3 groundAmb = mix(vec3(0.012, 0.010, 0.008), vec3(0.10, 0.085, 0.065), dayF) * AMBIENT_INTENSITY;
    vec3 ambient = mix(groundAmb, skyAmb, n.y * 0.5 + 0.5) * (0.25 + 0.75 * lm.g) * ssao + vec3(0.006);
    vec3 blockLight = vec3(1.0, 0.52, 0.20) * (lm.r * lm.r * 1.6 + lm.r * 0.4) * TORCH_INTENSITY;
    vec3 direct = lightCol * ndl * shadow * smoothstep(0.0, 0.35, lm.g);

    vec3 result;
    if (abs(mat - MAT_WATER) < 0.5) {
        vec3 refr = pow(max(col, vec3(0.0)), vec3(2.2));
        refr *= exp(-vec3(0.55, 0.22, 0.12) * gb1.b * 0.6);
        refr = mix(refr, vec3(0.015, 0.075, 0.13) * (0.25 + 0.75 * lm.g) * (0.4 + 0.6 * dayF),
                   clamp(gb1.b * 0.22, 0.0, 0.85));
        refr = mix(refr, vec3(0.75, 0.82, 0.88) * (0.25 + 0.75 * lm.g), clamp(gb1.a, 0.0, 1.0) * 0.85);
        result = refr;
    } else {
        vec3 albedo = pow(max(col, vec3(0.0)), vec3(2.2));
        result = albedo * (direct + ambient + blockLight * ssao);
        result += albedo * emiss * 4.0;
    }
    gl_FragData[0] = vec4(result, 1.0);
}
