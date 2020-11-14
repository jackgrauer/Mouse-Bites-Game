/*
An RGB-based color invert shader
*/

/*
INITIALIZATION
*/

//Initialize input uniforms
uniform float in_Amount;        //Real (0-1)
uniform float in_Time;          //Seconds
uniform vec2 in_Mouse;          //X/Y
uniform vec2 in_Resolution;     //X/Y (W/H)

//Initialize texture values
varying vec2 v_vTexcoord;       //X/Y
varying vec4 v_vColor;          //RGBA


/*
PERFORM FRAGMENT SHADER
*/

void main() {
   //Get sampler element color
   vec4 texel = texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor;
   
   //Get negative color and fade results in/out
   texel.rgb = mix(texel.rgb, 1.0 - texel.rgb, in_Amount);
   
   //Return final color
   gl_FragColor = texel;
}