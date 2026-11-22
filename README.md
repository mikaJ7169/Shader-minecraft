# Mistral Ultra Shaders — pack de shaders Minecraft 1.18.2

Pack de shaders complet (format Iris / OptiFine, GLSL 150) pensé pour le rendu le plus beau possible, sans compromis de performances : ombres douces haute résolution, réflexions screen-space, eau animée avec réfraction et écume, brouillard volumétrique avec rayons de soleil, SSAO, bloom HDR, tonemapping ACES et étalonnage colorimétrique.

## Installation (Minecraft 1.18.2)

1. Installe **Iris Shaders** pour 1.18.2 (Fabric, avec Sodium) — recommandé — ou OptiFine 1.18.2.
2. Télécharge ce dépôt en ZIP (`Code > Download ZIP`) et place le fichier `.zip` dans `.minecraft/shaderpacks/`.
3. Lance le jeu : **Options vidéo > Shader Packs** (ou `Shader Packs` dans Iris) > sélectionne le pack.
4. Ouvre **Shader Pack Settings** pour régler tous les effets (voir ci-dessous).

> Le pack cible le pipeline Iris/OptiFine en `#version 150`. Sur OptiFine pur, si un shader échoue, réduis d'abord `SHADOW_MAP_RES` à 2048.

## Pipeline de rendu

| Passe | Rôle |
|---|---|
| `shadow` | Shadow map avec distorsion + `shadowMapResolution` réglable (jusqu'à 8192) |
| `gbuffers_terrain/entities/hand` | G-buffers : albédo, lightmap, normale monde, lillance, émissif, mouillage (pluie) |
| `gbuffers_water` | Normale de vagues procédurale (sines + fbm), réfraction écran, écume de rivage, profondeur d'eau |
| `gbuffers_skybasic` | Ciel atmosphérique, halo solaire, lune, étoiles scintillantes, brume d'horizon |
| `gbuffers_clouds` | Nuages procéduraux (fbm) avec auto-ombrage et fondu à distance |
| `composite1` | SSAO (échantillonnage hémisphère) |
| `composite2` | Ombres PCF douces (spirale de Vogel, pénombre réglable, ombres colorées translucides) |
| `composite3` | Éclairage différé : soleil/lune + ombres, ambiant hémisphérique, torches, émissifs, eau (absorption + écume) |
| `composite4` | Réflexions screen-space (raymarch) + spéculaire GGX (Fresnel de Schlick) |
| `composite5` | Brouillard volumétrique en hauteur + god rays échantillonnés dans la shadow map |
| `composite6/7`, `deferred1` | Bloom HDR (seuil + double flou gaussien) |
| `final` | Bloom final, exposition, ACES, gamma, saturation/contraste/température, vignettage, dithering anti-banding |

Les tampons scène/bloom (`colortex0/6/7`) sont en **RGBA16F** pour préserver la plage HDR.

## Réglages (Shader Pack Settings)

- **LIGHTING** : `SHADOW_MAP_RES`, `SHADOW_SAMPLES`, `SHADOW_PENUMBRA`, intensités soleil/lune/ambiant/torches, `SSAO_*`, `SSR_STEPS`, `SSR_THICKNESS`
- **ATMOSPHERE** : `FOG_DENSITY`, `VOL_SAMPLES`, `GODRAYS`, `CLOUD_COVER`, `WATER_DETAIL`, `WETNESS`, `STAR_BRIGHTNESS`
- **POSTFX** : `BLOOM_STRENGTH`, `BLOOM_THRESHOLD`, `EXPOSURE`, `CONTRAST`, `SATURATION`, `TEMPERATURE`, `VIGNETTE`

## Conseils

- PC très puissant : `SHADOW_MAP_RES 8192`, `SHADOW_SAMPLES 64`, `SSR_STEPS 128`, `VOL_SAMPLES 128`, `SSAO_SAMPLES 32`.
- Si les perfs baissent : descends d'abord `SHADOW_MAP_RES`, puis `VOL_SAMPLES` et `SSR_STEPS`.
- Le pack est volontairement gourmand (god rays = un échantillon de shadow map par pas volumétrique) : c'est le prix du "beau" demandé.

## Structure du dépôt

```
shaders/
  shaders.properties        # écrans et sliders du menu de réglages
  shadow.vsh/.fsh           # passe shadow map
  gbuffers_*.vsh/.fsh       # passes géométrie (terrain, eau, ciel, nuages, entités, main)
  composite1..7.vsh/.fsh    # SSAO, ombres, éclairage, SSR, volumétrie, bloom
  deferred1.vsh/.fsh        # 2e flou de bloom
  final.vsh/.fsh            # tonemapping + post-traitement
  include/                  # bibliothèques GLSL partagées (settings, common, noise, ...)
```
