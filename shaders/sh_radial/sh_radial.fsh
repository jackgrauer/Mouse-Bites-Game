/*
A simple radial blur effect shader
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

//Set blur strength
const float blur = 0.05;

//Set blur quality
const int sample_count = 12;

//Perform blur
void main() {
    //Initialize variables for calculating blur
	int	 sindex = 0;
    vec4 texel = vec4(0.0);
	
	//Get blur position
	vec2 blur_pos = (gl_FragCoord.xy/in_Resolution.xy) - 0.5;
    
	//Get blur scale
    float blur_scale = (1.0/(float(sample_count) - 1.0))*(blur*in_Amount);
    
	//Apply blur to base texture
    for (sindex = 0; sindex < sample_count; sindex++) {
        float scale = 1.0 - (blur*in_Amount) + (float(sindex)*blur_scale);
        texel += texture2D(gm_BaseTexture, (blur_pos*scale) + 0.5);
    }
    
	//Normalize final color
    texel /= float(sample_count);
    
	//Return final color
	gl_FragColor = texel*v_vColor;
}