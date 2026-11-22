#version 150

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"
#include "/include/distort.glsl"
#include "/include/shadows.glsl"

/* RENDERTARGETS: 0,5 */

in vec2 texcoord;

void main() {
    vec3 scene = texture(colortex0, texcoord).rgb;
    float depth = texture(depthtex0, texcoord).r;
    float mat = decodeMat(texture(colortex2, texcoord).a);
    float prevSsao = texture(colortex5, texcoord).r;
    float shadow = 1.0;
    if (depth < 1.0 && abs(mat - MAT_CLOUD) > 0.5) {
        vec3 wp = screenToWorld(texcoord, depth);
        vec3 n = normalize(decodeNormal(texture(colortex2, texcoord).rgb));
        vec3 sunDirW = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
        float ndl = dot(n, sunDirW);
        float bias = clamp(0.002 * (1.0 - max(ndl, 0.0)), 0.0006, 0.02);
        vec4 clip = shadowProjection * (shadowModelView * vec4(wp, 1.0));
        clip.z -= bias;
        float dist = length(wp - cameraPosition);
        shadow = luminance(getSoftShadow(clip, texcoord, SHADOW_PENUMBRA * (1.0 + dist * 0.01)));
    }
    gl_FragData[0] = vec4(scene, 1.0);
    gl_FragData[1] = vec4(prevSsao, shadow, 0.0, 1.0);
}
