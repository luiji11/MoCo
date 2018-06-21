#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float mean;
uniform float contrast;
uniform float k;
uniform float l;
uniform float s;

const float PI = 3.1415926535;

void main( void ) {

    float arg = 2.0*PI*((gl_FragCoord.x * k+ gl_FragCoord.y * l)/resolution.y);
    float color = mean+s*contrast*(sin(arg)+cos(arg));
    
    gl_FragColor = vec4( color, color, color, 1.0 );

}