// ============================================================
//  Ciel : degrade atmospherique, diffusion autour du soleil,
//  lune, etoiles, brume d'horizon.
//  A inclure apres common.glsl, noise.glsl et settings.glsl.
// ============================================================

vec3 skyColorAt(vec3 dir, vec3 sunDir, float dayF) {
    float h = clamp(dir.y, 0.0, 1.0);
    vec3 zenith = mix(vec3(0.004, 0.008, 0.020), vec3(0.10, 0.32, 0.72), dayF);
    vec3 horizon = mix(vec3(0.020, 0.030, 0.060), vec3(0.62, 0.74, 0.92), dayF);
    vec3 col = mix(horizon, zenith, pow(h, 0.55));
    float s = max(dot(dir, sunDir), 0.0);
    col += vec3(1.0, 0.75, 0.45) * pow(s, 700.0) * 3.0 * dayF;
    col += vec3(1.0, 0.62, 0.32) * pow(s, 24.0) * 0.35 * dayF;
    col += vec3(0.85, 0.55, 0.35) * pow(s, 3.0) * 0.10 * dayF;
    col = mix(col, vec3(0.55, 0.62, 0.75) * (0.15 + 0.85 * dayF), pow(1.0 - h, 8.0) * 0.8);
    return col;
}

vec3 starLayer(vec3 dir, float intensity) {
    if (intensity <= 0.0 || dir.y <= 0.0) {
        return vec3(0.0);
    }
    vec2 uv = vec2(atan(dir.x, dir.z), asin(clamp(dir.y, -1.0, 1.0))) * 55.0;
    vec2 cell = floor(uv);
    vec2 f = fract(uv) - 0.5;
    float h = hash12(cell);
    vec3 col = vec3(0.0);
    if (h > 0.996) {
        vec2 sp = hash22(cell) - 0.5;
        float d = length(f - sp);
        float tw = 0.6 + 0.4 * sin(frameTime * 2.0 + h * 80.0);
        col = vec3(0.85, 0.90, 1.0) * smoothstep(0.10, 0.0, d) * tw * (h - 0.996) * 250.0;
    }
    return col * intensity;
}

vec3 moonLayer(vec3 dir, vec3 moonDir, float nightF) {
    float d = dot(dir, moonDir);
    float disc = smoothstep(0.99965, 0.99985, d);
    float maria = fbm(vec2(atan(dir.x, dir.z), dir.y) * 30.0);
    vec3 col = vec3(0.85, 0.88, 0.95) * disc * (0.55 + 0.45 * maria) * 1.5;
    col += vec3(0.5, 0.55, 0.7) * pow(max(d, 0.0), 900.0) * 0.4;
    return col * nightF;
}
