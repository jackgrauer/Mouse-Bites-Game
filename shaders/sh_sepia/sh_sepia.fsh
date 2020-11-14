/*
A sepia tone shader
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
varying vec2 v_vTexcoord;      //X/Y
varying vec4 v_vColor;         //RGBA


/*
PERFORM FRAGMENT SHADER
*/

void main() {
   //Get sampler element color
   vec4 texel = texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor;
   vec4 sepia = texel.rgba;
   
   //Average colors with sepia bias
   sepia.r = (texel.r*0.52) + (texel.g*0.35) + (texel.b*0.13);
   sepia.g = (texel.r*0.23) + (texel.g*0.46) + (texel.b*0.17);
   sepia.b = (texel.r*0.06) + (texel.g*0.28) + (texel.b*0.32);
   
   //Return final color and fade results in/out
   gl_FragColor = mix(texel, sepia, in_Amount);
}