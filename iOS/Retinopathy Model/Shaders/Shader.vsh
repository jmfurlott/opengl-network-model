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
    mat4 rot = mat4(rot_0, rot1, rot2, rot3); //remember that these are the 0,1,2, and 3rd columns!!
    
    vec4 model = a_position + vec4(-.9, -0.6, 0.0, 1.0);
    
    float x = scale * (model.x*rot[0][0] + model.y*rot[1][0] + model.z*rot[2][0] + model.w*rot[3][0]);
    float y = scale * (model.x*rot[0][1] + model.y*rot[1][1] + model.z*rot[2][1] + model.w*rot[3][1]);
    float z = scale * (model.x*rot[0][2] + model.y*rot[1][2] + model.z*rot[2][2] + model.w*rot[3][2]);
    //float w = scale * (model.x*rot[0][3] + model.y*rot[1][3] + model.z*rot[2][3] + model.w*rot[3][3]);





    gl_Position = vec4(x,y,z,1);
    



    

}