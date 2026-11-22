#version 120

#include "/include/settings.glsl"
#include "/include/common.glsl"

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 viewPos;
varying vec3 worldPos;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    vec2 lm = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    lmcoord = lm / (30.0 / 32.0) - (1.0 / 32.0);
    glcolor = gl_Color;
    normal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
}
