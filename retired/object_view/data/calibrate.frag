#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 mouse;

uniform float r,g,b;

void main( void ) {

gl_FragColor = vec4( r, g, b, 1.0 );

}