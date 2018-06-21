
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

const float PI = 3.1415926535;

void main( void ) {

float sth = sin(th);
float cth = cos(th);
float color;

color = mean+contrast*sin(2.0*PI*( (gl_FragCoord.x*cth + gl_FragCoord.y*sth) / sper ) + sphase);

gl_FragColor = vec4(color,color,color, 1.0 );

}