// ============================================================
//  Echantillonnage de la shadow map : ombre dure + ombre coloree
//  (transparence) + PCF doux avec noyau en spirale de Vogel.
//  A inclure apres common.glsl et distort.glsl.
// ============================================================

vec3 getShadow(vec3 ssp) {
    if (ssp.x < 0.0 || ssp.x > 1.0 || ssp.y < 0.0 || ssp.y > 1.0 || ssp.z > 1.0) {
        return vec3(1.0);
    }
    float transparent = step(ssp.z, texture2D(shadowtex0, ssp.xy).r);
    if (transparent > 0.5) {
        return vec3(1.0);
    }
    float opaque = step(ssp.z, texture2D(shadowtex1, ssp.xy).r);
    if (opaque < 0.5) {
        return vec3(0.0);
    }
    vec4 sc = texture2D(shadowcolor0, ssp.xy);
    return sc.rgb * (1.0 - sc.a);
}

vec3 getSoftShadow(vec4 clipPos, vec2 uv, float radiusPx) {
    vec3 accum = vec3(0.0);
    float th = getNoise2(uv).r * TAU;
    for (int i = 0; i < SHADOW_SAMPLES; i++) {
        float fi = float(i) + 0.5;
        float r = radiusPx * sqrt(fi / float(SHADOW_SAMPLES));
        float a = fi * 2.39996 + th;
        vec2 off = vec2(cos(a), sin(a)) * r * 2.0 / float(shadowMapResolution);
        vec4 cp = clipPos + vec4(off, 0.0, 0.0);
        cp.xyz = distortShadowClipPos(cp.xyz);
        vec3 ssp = cp.xyz / cp.w * 0.5 + 0.5;
        accum += getShadow(ssp);
    }
    return accum / float(SHADOW_SAMPLES);
}
