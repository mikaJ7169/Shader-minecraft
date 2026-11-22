// ============================================================
//  Options utilisateur (affichees dans "Shader Pack Settings").
//  La liste de valeurs apres "//" definit les paliers du slider.
// ============================================================

// --- Ombres ---
#define SHADOW_MAP_RES 4096 // 1024, 2048, 4096, 8192
#define SHADOW_SAMPLES 24 // 4, 8, 16, 24, 32, 48, 64
#define SHADOW_PENUMBRA 2.0 // 0.5, 1.0, 1.5, 2.0, 3.0, 4.0

// --- Reflets screen-space (SSR) ---
#define SSR_STEPS 64 // 16, 32, 48, 64, 96, 128
#define SSR_THICKNESS 0.15 // 0.05, 0.10, 0.15, 0.25, 0.40

// --- Occlusion ambiante (SSAO) ---
#define SSAO_SAMPLES 16 // 4, 8, 16, 24, 32
#define SSAO_RADIUS 1.5 // 0.5, 1.0, 1.5, 2.0, 3.0
#define SSAO_STRENGTH 1.2 // 0.0, 0.5, 1.0, 1.2, 1.6, 2.0

// --- Brouillard volumetrique / rayons de soleil ---
#define VOL_SAMPLES 64 // 16, 32, 64, 96, 128
#define GODRAYS 1 // 0, 1
#define FOG_DENSITY 0.012 // 0.0, 0.004, 0.008, 0.012, 0.02, 0.04, 0.08

// --- Eau / ciel / atmosphere ---
#define WATER_DETAIL 2.0 // 0.5, 1.0, 1.5, 2.0, 3.0
#define CLOUD_COVER 0.5 // 0.0, 0.25, 0.5, 0.7, 0.9
#define STAR_BRIGHTNESS 1.0 // 0.0, 0.5, 1.0, 1.5, 2.0
#define WETNESS 1.0 // 0.0, 0.5, 1.0

// --- Lumiere ---
#define SUN_INTENSITY 1.25 // 0.5, 0.8, 1.0, 1.25, 1.6, 2.0
#define MOON_INTENSITY 0.35 // 0.1, 0.2, 0.35, 0.5, 0.8
#define AMBIENT_INTENSITY 1.0 // 0.25, 0.5, 0.75, 1.0, 1.5, 2.0
#define TORCH_INTENSITY 1.1 // 0.5, 0.8, 1.0, 1.1, 1.4, 1.8

// --- Post-traitement ---
#define BLOOM_STRENGTH 0.35 // 0.0, 0.15, 0.25, 0.35, 0.5, 0.8
#define BLOOM_THRESHOLD 1.0 // 0.5, 0.75, 1.0, 1.5, 2.0
#define EXPOSURE 1.0 // 0.6, 0.8, 1.0, 1.2, 1.4
#define CONTRAST 1.06 // 0.9, 1.0, 1.06, 1.12, 1.2
#define SATURATION 1.12 // 0.8, 0.95, 1.0, 1.12, 1.25, 1.5
#define TEMPERATURE 0.0 // -0.15, -0.08, 0.0, 0.08, 0.15
#define VIGNETTE 0.32 // 0.0, 0.15, 0.32, 0.5, 0.7
