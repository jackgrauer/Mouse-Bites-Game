/*
An approximate blur-based bloom shader
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

//Set bloom strength
const float bloom = 20.0;

//Set bloom quality
const int sample_count = 32;
const int sample_quality = 8;
   
//Initialize contrast function
vec3 contrast(vec3 val, float bright, float cont) {
   return ((val - 0.5)*cont) + 0.5 + bright;
}

//Initialize blending function
vec3 screen(vec3 src, vec3 dest) {
   return src + dest - (src*dest);
}

//Perform bloom
void main() {
   //Initialize bloom parameters
   float rev = 6.2831853;
   float scale = max(0.25, (in_Resolution.x*in_Resolution.y)/1440000.0);
   vec3  size = vec3(in_Resolution, bloom*scale);
   vec2  radius = (size.z/size.xy);
   
   //Initialize variables for calculating bloom
   float xindex, yindex;
   vec4  texel = texture2D(gm_BaseTexture, v_vTexcoord);
   
   //Calculate bloom
   for (xindex = 0.0; xindex < rev; xindex += (rev/float(sample_count))) {
      for (yindex = (1.0/float(sample_quality)); yindex <= 1.0; yindex += (1.0/float(sample_quality))) {
         texel += texture2D(gm_BaseTexture, v_vTexcoord + (vec2(cos(xindex), sin(xindex))*yindex)*radius);
      }
   }
   
   //Normalize final color
   texel /= float(sample_count*sample_quality) + 1.0;
   
   //Adjust contrast to highlight bright areas
   texel.rgb = contrast(texel.rgb, -0.28, 0.76);
   
   //Blend final bloom
   texel = vec4(screen(texture2D(gm_BaseTexture, v_vTexcoord).rgb*v_vColor.rgb, v_vColor.rgb*texel.rgb), texture2D(gm_BaseTexture, v_vTexcoord).a*v_vColor.a);
   
   //Return final color and fade results in/out
   gl_FragColor = mix(texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor, texel, in_Amount);
}