#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/textures.glsl"
#include "/include/noise.glsl"

/* RENDERTARGETS: 0,5 */

varying vec2 texcoord;

void main() {
    vec3 scene = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;
    float ssao = 1.0;
    if (depth < 1.0) {
        vec3 vp = screenToView(texcoord, depth);
        vec3 nView = normalize(mat3(gbufferModelView) * decodeNormal(texture2D(colortex2, texcoord).rgb));
        float radius = SSAO_RADIUS * (0.06 + 0.012 * -vp.z);
        float occ = 0.0;
        for (int i = 0; i < SSAO_SAMPLES; i++) {
            vec2 h1 = hash22(vec2(float(i) * 12.9898 + texcoord.x * 78.233,
                                  float(i) * 39.346 + texcoord.y * 11.135) + float(frameCounter - 256 * (frameCounter / 256)));
            vec3 off = normalize(vec3(h1 * 2.0 - 1.0, hash11(float(i) * 7.13 + texcoord.x * 3.7 + texcoord.y * 9.1)));
            if (dot(off, nView) < 0.0) {
                off = -off;
            }
            vec3 sp = vp + off * radius;
            vec4 c = gbufferProjection * vec4(sp, 1.0);
            vec2 suv = c.xy / c.w * 0.5 + 0.5;
            if (suv.x >= 0.0 && suv.x <= 1.0 && suv.y >= 0.0 && suv.y <= 1.0) {
                float sceneZ = linearizeDepth(texture2D(depthtex0, suv).r);
                occ += clamp((sceneZ + 0.03 + sp.z) / radius, 0.0, 1.0);
            }
        }
        ssao = clamp(1.0 - (occ / float(SSAO_SAMPLES)) * SSAO_STRENGTH, 0.0, 1.0);
    }
    gl_FragData[0] = vec4(scene, 1.0);
    gl_FragData[1] = vec4(ssao, 0.0, 0.0, 1.0);
}
