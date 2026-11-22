#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"
#include "/include/noise.glsl"

/*
const int colortex0Format = RGBA16F;
const int colortex6Format = RGBA16F;
const int colortex7Format = RGBA16F;
*/

/* RENDERTARGETS: 0,1,2,3,4 */

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;

void main() {
    vec4 tex = texture2D(gtexture, texcoord);
    if (tex.a < 0.1) {
        discard;
    }
    vec3 albedo = tex.rgb * glcolor.rgb;
    float lum = luminance(tex.rgb);
    float emiss = smoothstep(0.82, 1.0, lmcoord.x) * smoothstep(0.28, 0.5, lum);
    float wet = clamp(rainStrength * WETNESS, 0.0, 1.0);
    float smooth = clamp(mix(0.06, 0.55, wet) + emiss * 0.2, 0.0, 1.0);

    gl_FragData[0] = vec4(albedo, 1.0);
    gl_FragData[1] = vec4(lmcoord, 0.0, 1.0);
    gl_FragData[2] = vec4(encodeNormal(normalize(normal)), encodeMat(MAT_TERRAIN));
    gl_FragData[3] = vec4(smooth, 0.0, emiss, wet);
    gl_FragData[4] = vec4(albedo, 1.0);
}
