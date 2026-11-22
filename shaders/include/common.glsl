// ============================================================
//  Uniforms communs + helpers de conversion d'espaces.
//  A inclure apres settings.glsl dans chaque programme.
// ============================================================

#define PI 3.14159265359
#define TAU 6.28318530718

#define MAT_TERRAIN 0.0
#define MAT_WATER 1.0
#define MAT_SKY 2.0
#define MAT_CLOUD 3.0

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;

uniform vec3 cameraPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform vec3 shadowLightPosition;
uniform vec3 skyColor;
uniform vec3 fogColor;

uniform float near;
uniform float far;
uniform float frameTime;
uniform int frameCounter;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float viewWidth;
uniform float viewHeight;
uniform float eyeAltitude;
uniform int worldTime;
uniform float hideGUI;

vec3 projectAndDivide(mat4 proj, vec3 pos) {
    vec4 h = proj * vec4(pos, 1.0);
    return h.xyz / h.w;
}

float linearizeDepth(float depth) {
    float z = depth * 2.0 - 1.0;
    return 2.0 * near * far / (far + near - z * (far - near));
}

vec3 screenToView(vec2 uv, float depth) {
    return projectAndDivide(gbufferProjectionInverse, vec3(uv * 2.0 - 1.0, depth * 2.0 - 1.0));
}

vec3 screenToWorld(vec2 uv, float depth) {
    vec3 v = screenToView(uv, depth);
    return (gbufferModelViewInverse * vec4(v, 1.0)).xyz;
}

vec3 viewToWorldDir(vec3 v) {
    return mat3(gbufferModelViewInverse) * v;
}

vec3 encodeNormal(vec3 n) { return n * 0.5 + 0.5; }
vec3 decodeNormal(vec3 n) { return normalize(n * 2.0 - 1.0); }
float encodeMat(float m) { return m / 255.0; }
float decodeMat(float a) { return a * 255.0; }
float luminance(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

float worldDayFactor() {
    float wt = float(worldTime % 24000);
    float day = 1.0 - smoothstep(11500.0, 13000.0, wt);
    float dawn = smoothstep(22800.0, 24000.0, wt);
    return clamp(day + dawn, 0.0, 1.0);
}

vec4 getNoise2(vec2 coord) {
    ivec2 sc = ivec2(coord * vec2(viewWidth, viewHeight));
    return texelFetch(noisetex, sc % 64, 0);
}
