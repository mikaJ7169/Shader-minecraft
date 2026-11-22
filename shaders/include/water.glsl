// ============================================================
//  Eau : hauteur de vague procédurale (sines + bruit) et normale
//  par differences finies.
//  A inclure apres common.glsl, noise.glsl et settings.glsl.
// ============================================================

float waveHeight(vec2 p, float t) {
    float d = WATER_DETAIL;
    float h = 0.0;
    h += sin(p.x * 1.5 * d + t * 1.7) * 0.35;
    h += sin(p.y * 2.3 * d - t * 1.3) * 0.25;
    h += sin((p.x + p.y) * 3.1 * d + t * 2.1) * 0.15;
    h += (snoise2(p * 1.2 * d + vec2(t * 0.8, -t * 0.6)) - 0.5) * 0.60;
    h += (snoise2(p * 3.7 * d - vec2(t * 1.1, t * 0.9) + 11.0) - 0.5) * 0.25;
    return h;
}

vec3 calcWaterNormal(vec3 worldPos, float t, float dist) {
    float e = 0.06 + dist * 0.004;
    float hL = waveHeight(worldPos.xz - vec2(e, 0.0), t);
    float hR = waveHeight(worldPos.xz + vec2(e, 0.0), t);
    float hD = waveHeight(worldPos.xz - vec2(0.0, e), t);
    float hU = waveHeight(worldPos.xz + vec2(0.0, e), t);
    float strength = 2.2 / clamp(dist * 0.02 + 0.4, 0.4, 2.0);
    return normalize(vec3((hL - hR) * strength, 2.0 * e, (hD - hU) * strength));
}
