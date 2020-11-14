/*
An approximate gaussian blur shader
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
const float blur = 8.0;

//Set blur quality
const int sample_count = 32;
const int sample_quality = 8;

//Perform blur
void main() {
   //Initialize blur parameters
   float rev = 6.2831853;
   float scale = max(0.5, (in_Resolution.x*in_Resolution.y)/1440000.0);
   vec3  size = vec3(in_Resolution, blur*scale);
   vec2  radius = (size.z/size.xy);
   
   //Initialize variables for calculating blur
   float xindex, yindex;
   vec4  texel = texture2D(gm_BaseTexture, v_vTexcoord);
   
   //Calculate blur
   for (xindex = 0.0; xindex < rev; xindex += (rev/float(sample_count))) {
      for (yindex = (1.0/float(sample_quality)); yindex <= 1.0; yindex += (1.0/float(sample_quality))) {
         texel += texture2D(gm_BaseTexture, v_vTexcoord + (vec2(cos(xindex), sin(xindex))*yindex)*radius);
      }
   }
   
   //Normalize final color
   texel /= float(sample_count*sample_quality) + 1.0;
   
   //Return final color and fade results in/out
   gl_FragColor = mix(texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor, texel*v_vColor, in_Amount);
}