/*
A bidirectional sine wave shader
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

//Initialize texture values
varying vec2 v_vTexcoord;       //X/Y
varying vec4 v_vColor;          //RGBA


/*
PERFORM FRAGMENT SHADER
*/

//Set wave properties
const int freq = 10;
const float amp = 0.5;
const float speed = 1.0;

void main() {   
   //Get wave time
   float time = (in_Time*speed);
   
   //Get wave phase
   vec2 phase = vec2(sin((v_vTexcoord.y*float(freq)) + time)*(amp*0.025), cos((v_vTexcoord.x*float(freq)) + time)*(amp*0.025))*in_Amount;
   
   //Get sampler element color
   vec4 texel = texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + phase.x, v_vTexcoord.y + phase.y))*v_vColor;
   
   //Return fragment
   gl_FragColor = texel;
}