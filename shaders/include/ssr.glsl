// ============================================================
//  Reflets screen-space : raymarch dans l'espace vue contre
//  depthtex0, lecture de la couleur ecran au point d'impact.
//  A inclure apres common.glsl et settings.glsl.
// ============================================================

vec3 ssrTrace(vec2 uv, vec3 viewPos, vec3 reflDirView, out float hitMask) {
    hitMask = 0.0;
    if (reflDirView.z > -0.02) {
        return vec3(0.0);
    }
    float stepLen = max(0.06, -viewPos.z * 0.015);
    vec3 pos = viewPos;
    for (int i = 0; i < SSR_STEPS; i++) {
        pos += reflDirView * stepLen;
        stepLen *= 1.07;
        float rayZ = -pos.z;
        if (rayZ > 80.0) {
            break;
        }
        vec4 clip = gbufferProjection * vec4(pos, 1.0);
        vec3 ndc = clip.xyz / clip.w;
        vec2 suv = ndc.xy * 0.5 + 0.5;
        if (suv.x < 0.0 || suv.x > 1.0 || suv.y < 0.0 || suv.y > 1.0) {
            break;
        }
        float sceneZ = linearizeDepth(texture2D(depthtex0, suv).r);
        if (rayZ > sceneZ && rayZ - sceneZ < SSR_THICKNESS) {
            float edge = smoothstep(0.0, 0.08, suv.x) * smoothstep(1.0, 0.92, suv.x)
                       * smoothstep(0.0, 0.08, suv.y) * smoothstep(1.0, 0.92, suv.y);
            hitMask = edge;
            return texture2D(colortex0, suv).rgb;
        }
    }
    return vec3(0.0);
}
