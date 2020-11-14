/*
An edge chromatic aberration shader
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

//Set chromatic separation strength
const float sep = 1.75;

//Perform chromatic aberration
void main() {
   //Initialize chromatic aberration properties
   vec2  frag = in_Resolution*v_vTexcoord;
   float frag_sep = 0.001*sep;
   vec2  frag_coord = max(vec2(0.0), v_vTexcoord - frag_sep);
   float width = in_Resolution.x*0.5;
   float amt = ((frag.x - width)/width)*frag_sep;
   vec4  texel = vec4(0.0);
   
   //Separate color channels
   texel.r = (texture2D(gm_BaseTexture, vec2(frag_coord.x - amt, frag_coord.y + amt))*v_vColor).r;
   texel.g = (texture2D(gm_BaseTexture, vec2(frag_coord.x, frag_coord.y + amt))*v_vColor).g;
   texel.b = (texture2D(gm_BaseTexture, vec2(frag_coord.x + amt, frag_coord.y - amt))*v_vColor).b;
   
   //Get alpha channel
   texel.a = (texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor).a;
   
   //Return final color and fade results in/out
   gl_FragColor = mix(texture2D(gm_BaseTexture, v_vTexcoord)*v_vColor, texel, in_Amount);   
}