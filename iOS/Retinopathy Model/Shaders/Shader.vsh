precision mediump float;

attribute vec4 a_position;
attribute vec4 a_color;
uniform mat4 rotation;
uniform mat4 projectionMatrix;

uniform float scale;


varying vec4 v_color;

void main() {
    //gl_Position = a_position + vec4(-1.0,-0.5,0.0,1.0);
    v_color = a_color;
    
    
    //matrix logic
    mat4 id = mat4(scale);
    
    vec4 some = a_position + vec4(-1.0, -0.5, 0.0, 1.0);
    
    float x = id[0][0] * some.x;
    float y = id[1][1] * some.y;
    float z = id[2][2] * some.z;

    

    gl_Position = vec4(x,y,z,1);


    

}