// ============================================================
//  Brouillard volumetrique exponentiel en hauteur + rayons de
//  soleil (god rays) echantillonnes dans la shadow map.
//  A inclure apres common.glsl, distort.glsl, lighting.glsl.
// ============================================================

void volumetrics(vec2 uv, vec3 worldPos, float dist, out vec3 inscatter, out float transmittance) {
    vec3 sunDirW = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
    float dayF = worldDayFactor();
    vec3 sunCol = sunLightColor();
    vec3 ambCol = mix(vec3(0.020, 0.030, 0.060), vec3(0.20, 0.28, 0.42), dayF) * AMBIENT_INTENSITY;
    vec3 rayDir = dist > 0.001 ? (worldPos - cameraPosition) / dist : vec3(0.0, 1.0, 0.0);
    float maxDist = min(dist, 200.0);
    float stepSize = maxDist / float(VOL_SAMPLES);
    vec3 sum = vec3(0.0);
    float trans = 1.0;
    for (int i = 0; i < VOL_SAMPLES; i++) {
        float fi = (float(i) + 0.5) / float(VOL_SAMPLES);
        vec3 p = cameraPosition + rayDir * maxDist * fi;
        float heightFog = exp(-max(p.y - 62.0, 0.0) * 0.015);
        float density = FOG_DENSITY * (0.3 + 0.7 * heightFog);
        float light = 1.0;
        if (GODRAYS == 1 && dayF > 0.02) {
            vec4 clip = shadowProjection * (shadowModelView * vec4(p, 1.0));
            clip.xyz = distortShadowClipPos(clip.xyz);
            vec3 ssp = clip.xyz / clip.w * 0.5 + 0.5;
            if (ssp.x >= 0.0 && ssp.x <= 1.0 && ssp.y >= 0.0 && ssp.y <= 1.0 && ssp.z <= 1.0) {
                light = step(ssp.z - 0.002, texture2D(shadowtex0, ssp.xy).r);
            }
        }
        sum += (sunCol * light + ambCol) * density * stepSize * trans;
        trans *= exp(-density * stepSize);
        if (trans < 0.02) {
            break;
        }
    }
    inscatter = sum;
    transmittance = trans;
}
