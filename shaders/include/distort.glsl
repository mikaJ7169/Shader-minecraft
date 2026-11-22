// ============================================================
//  Shadow map : resolution, distorsion de la projection et
//  conversion monde -> espace ecran de l'ombre.
//  A inclure apres settings.glsl.
// ============================================================

const int shadowMapResolution = SHADOW_MAP_RES;
const float shadowDistanceRenderMul = 1.0;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowcolor0Nearest = true;

vec3 distortShadowClipPos(vec3 p) {
    float d = length(p.xy) + 0.1;
    p.xy /= d;
    p.z *= 0.5;
    return p;
}
