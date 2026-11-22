// Samplers + noise texture (FRAGMENT uniquement : les samplers sont
// interdits en vertex shader en GLSL 120).

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

vec4 getNoise2(vec2 coord) {
    vec2 nc = mod(floor(coord * vec2(viewWidth, viewHeight)), 64.0);
    return texture2D(noisetex, (nc + 0.5) / 64.0);
}
