
#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;

uniform float mean;
uniform float contrast;
uniform float tper;
uniform float sper;
uniform float th;
uniform float th_speed;
uniform float separable;

const float PI = 3.1415926535;

// Screen calibration data

void main( void ) {

float th0 = th+th_speed*time;
float sth = sin(th0);
float cth = cos(th0);
float color;

if(separable>0.0)
color = mean+contrast*sin(2.0*PI*((gl_FragCoord.x*cth + gl_FragCoord.y*sth)/sper))*cos(2.0*PI*time/tper);
else
color = mean+contrast*sin(2.0*PI*((gl_FragCoord.x*cth + gl_FragCoord.y*sth)/sper+time/tper));

gl_FragColor = vec4(color,color,color, 1.0 );

}