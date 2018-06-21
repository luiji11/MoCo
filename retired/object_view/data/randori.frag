
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;

uniform float mean;
uniform float contrast;
uniform float sper;
uniform float sphase;
uniform float th;
uniform float xpos;
uniform float ypos;
uniform float radius;

const float PI = 3.1415926535;

// Screen calibration data

void main( void ) {

float sth = sin(th);
float cth = cos(th);
float color;
float mask;

mask = ((gl_FragCoord.x-xpos)*(gl_FragCoord.x-xpos)+(gl_FragCoord.y-ypos)*(gl_FragCoord.y-ypos)) < (radius*radius);
color = mean+contrast*cos(2.0*PI*( ((gl_FragCoord.x-xpos)*cth + (gl_FragCoord.y-ypos)*sth)/sper) + sphase) * mask;

gl_FragColor = vec4(color,color,color, 1.0 );

}