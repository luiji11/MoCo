#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float side;
uniform float xpos[64];
uniform float ypos[64];
uniform float th[64];
uniform float ph[64];
uniform int ngabors;
uniform float tper;
uniform float radius;

const float PI = 3.1415926535;

void main( void ) {

    float dx,dy;
    float dx2;
    float dy2;
    float r2;
    float color;
    float sth;
    float cth;
    int ii;

    color = 0.0;
    
    for(ii = 0; ii < ngabors; ii++)
    {
        sth = sin(th[ii]);
        cth = cos(th[ii]);
        
        
        dx = gl_FragCoord.x - xpos[ii];
        dx2 = dx*dx;
        
        dy = gl_FragCoord.y - ypos[ii];
        dy2 = dy*dy;
        
        r2 = radius*radius;
        
        color += cos( (dx * cth + dy * sth) * 2.0 * PI / (5.0*radius) - ph[ii]) * exp(-(dx2+dy2)/(2.0*r2));
        
    }


    color = 0.5 + 2 * color;

    gl_FragColor = vec4( color, color, color, 1.0 );

}