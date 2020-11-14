/*
A simple scanline effect shader
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

//Set scanline height
const float height = 1.0;

//Set distortion speed
const float speed = 5.0;

//Set flicker speed
const float flicker = 10.0;

//Perform scanline
void main() {
	//Initialize scanline parameters
	vec2 scale = vec2(in_Resolution.x/1920.0, 1080.0/in_Resolution.y)*height;
	float scanline = sin((v_vTexcoord.y*in_Resolution.y)*scale.y)*0.1;
	
	//Initialize vignette parameters
	float vignette = length(v_vTexcoord - vec2(0.5, 0.5));
	vignette = smoothstep(0.0, 0.66, 1.0 - vignette);
	
	//Initialize distortion parameters
	float distortTime = (mod(in_Time*speed, 60.0)/60.0);
	float distort = 0.0;
	if (v_vTexcoord.y > distortTime) {
		if (v_vTexcoord.y < (distortTime + 0.005)) {
			distort = smoothstep(0.0, 0.025, length(v_vTexcoord.y - (distortTime + 0.0025)));
		}
	}
	
	//Get original color with distortion
	vec4 texel = (texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + distort, v_vTexcoord.y))*v_vColor);
	
	//Add scanline
	texel += scanline;
	
	//Add flicker
	texel += sin(in_Time*flicker)*0.016;
	
	//Add vignette
	texel *= vignette;
	
	//Return final color and fade results in/out
	gl_FragColor = texel*in_Amount;
}