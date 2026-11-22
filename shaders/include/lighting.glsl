// ============================================================
//  Eclairage PBR : Fresnel de Schlick, GGX, ambient
//  hemispherique, couleur soleil/lune.
//  A inclure apres common.glsl et settings.glsl.
// ============================================================

vec3 sunLightColor() {
    float d = worldDayFactor();
    vec3 moon = vec3(0.30, 0.42, 0.85) * MOON_INTENSITY;
    vec3 sun = vec3(1.0, 0.88, 0.70) * SUN_INTENSITY;
    return mix(moon, sun, d);
}

vec3 fresnelSchlick(float cosTheta, vec3 f0) {
    return f0 + (1.0 - f0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}

float distributionGGX(float ndh, float a) {
    float a2 = a * a;
    float f = (ndh * a2 - ndh) * ndh + 1.0;
    return a2 / (PI * f * f);
}

float geometrySmith(float ndv, float ndl, float a) {
    float k = (a + 1.0) * (a + 1.0) / 8.0;
    float gv = ndv / (ndv * (1.0 - k) + k);
    float gl = ndl / (ndl * (1.0 - k) + k);
    return gv * gl;
}

vec3 specularGGX(vec3 n, vec3 v, vec3 l, vec3 f0, float rough) {
    vec3 h = normalize(v + l);
    float ndv = max(dot(n, v), 0.0001);
    float ndl = max(dot(n, l), 0.0);
    float ndh = max(dot(n, h), 0.0);
    float a = max(rough * rough, 0.0001);
    vec3 F = fresnelSchlick(max(dot(h, v), 0.0), f0);
    float D = distributionGGX(ndh, a);
    float G = geometrySmith(ndv, ndl, a);
    return F * D * G / max(4.0 * ndv * ndl, 0.001);
}
