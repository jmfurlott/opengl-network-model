precision mediump float;

attribute vec4 a_position;
attribute vec4 a_color;

uniform vec4 rot_0;
uniform vec4 rot1;
uniform vec4 rot2;
uniform vec4 rot3;



uniform float scale;


varying vec4 v_color;

void main() {
    //gl_Position = a_position + vec4(-1.0,-0.5,0.0,1.0);
    v_color = a_color;
    
    
    //matrix logic
    mat4 id = mat4(rot_0, rot1, rot2, rot3); //remember that these are the 0,1,2, and 3rd columns!!
    
    vec4 some = a_position + vec4(-1.0, -0.5, 0.0, 1.0);
    
    float x = id[0][0] * some.x;
    float y = id[1][1] * some.y;
    float z = id[2][2] * some.z;

    

    gl_Position = vec4(x,y,z,1);


    

}