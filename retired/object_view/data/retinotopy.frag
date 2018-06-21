
#ifdef GL_ES
precision mediump float;
#endif


#define PROCESSING_COLOR_SHADER

#extension GL_EXT_gpu_shader4 : enable

uniform float th;
uniform float checker;
uniform float kappa;
uniform float frame;
uniform float speed;
uniform float contrast;
uniform float width;
uniform float height;

const float PI = 3.1415926535;

// Screen calibration data

void main( void ) {

float x,y,tmp;
float par;
float color;

x = gl_FragCoord.x;
y = gl_FragCoord.y;
tmp = height/width;


par = float( int( floor(x/checker) + floor(y/checker) ) % 2 ); 

color = (par - 0.5) * contrast;

switch(th){
	case 0:
		color = 0.5 + color * exp(kappa*cos((x-speed*frame)/width*2.0*PI))/exp(kappa);
		break;
	case 1:
		color = 0.5 + color * exp(kappa*cos((x+speed*frame)/width*2.0*PI))/exp(kappa);
		break;
	case 2:
		color = 0.5 + color * exp(kappa*tmp*cos((y-speed*frame)/height*2.0*PI))/exp(kappa*tmp);
	    break;
	case 3:
		color = 0.5 + color * exp(kappa*tmp*cos((y+speed*frame)/height*2.0*PI))/exp(kappa*tmp);
		break;
	default:
		color = 0.0;
		break;
}


gl_FragColor = vec4(color,color,color, 1.0 );


}