/*
A simple passthrough vertex shader
*/

/*
INITIALIZATION
*/

//Initialize input uniforms
uniform float in_Amount;        //Real (0-1)
uniform float in_Time;          //Seconds
uniform vec2 in_Mouse;          //X/Y
uniform vec2 in_Offset;         //X/Y
uniform vec2 in_Resolution;     //X/Y (W/H)

//Initialize attribute values
attribute vec3 in_Position;     //X/Y/Z
attribute vec3 in_Normal;       //X/Y/Z
attribute vec4 in_Color;        //RGBA
attribute vec2 in_TextureCoord; //UV

//Initialize texture values
varying vec2 v_vTexcoord;       //X/Y
varying vec4 v_vColor;          //RGBA


/*
PERFORM VERTEX SHADER
*/

void main() {
   vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
   gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*object_space_pos;
    
   v_vColor = in_Color;
   v_vTexcoord = in_TextureCoord;
}