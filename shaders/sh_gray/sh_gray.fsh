/*
A color-averaged grayscale (black and white) shader
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
   
   //Get grayscale luminosity
   vec3 val = vec3(0.29, 0.59, 0.11);
   
   //Apply and fade results in/out
   val = mix(texel.rgb, vec3(dot(texel.rgb, val)), in_Amount);
   
   //Return final color
   gl_FragColor = vec4(val.rgb, texel.a);   
}