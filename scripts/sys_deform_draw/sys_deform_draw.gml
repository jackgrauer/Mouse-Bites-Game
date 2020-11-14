/// @function	sys_deform_draw(entity, index, tex, width, height, x, y, xscale, yscale, rot, alpha);
/// @param		{integer}	entity
/// @param		{integer}	index
/// @param		{texture}	tex
/// @param		{real}		width
/// @param		{real}		height
/// @param		{real}		x
/// @param		{real}		y
/// @param		{real}		xscale
/// @param		{real}		yscale
/// @param		{real}		rot
/// @param		{real}		alpha
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function sys_deform_draw(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10) {

	/*
	==========================================================================
	SYSTEM FUNCTION: MODIFY AT YOUR OWN RISK!
	--------------------------------------------------------------------------
	  System functions are executed automatically by the engine and typically
	  should not be run manually by the user
	==========================================================================

	Draws deformations which have been performed with sys_deform_perform. Since
	each entity is unique, calculations to determ must be performed externally prior to executing
	this script

	VNgen's handling of this functionality is highly tailored for its particular
	use-cases and is not intended for general use.

	argument0  = the data structure for the entity to apply deformation to (integer)
	argument1  = the index of the row containing the target entity ID (integer)
	argument2  = the texture to be drawn as deformation (texture)
	argument3  = the original width of the source sprite or surface (real)
	argument4  = the original height of the source sprite or surface (real)
	argument5  = the horizontal position to draw the deformation (real)
	argument6  = the vertical position to draw the deformation (real)
	argument7  = the horizontal scale multiplier to apply to the deformation (real)
	argument8  = the vertical scale multiplier to apply to the deformation (real)
	argument9  = the rotation of the deformation, in degrees (real)
	argument10 = the alpha transparency value of the deformation (real) (0-1)

	Example usage:
	   sys_deform_draw(ds_textbox, ds_yindex, sprite_get_texture(action_sprite), 
	                   sprite_get_width(action_sprite), sprite_get_height(action_sprite), 
	                   action_x, action_y, action_xscale, action_yscale, action_rot, 
	                   ((action_alpha*action_anim_alpha)*action_fade_alpha)*global.vg_ui_alpha);
	*/

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for drawing deformation
	var point_x, point_y, point_width, point_height, point_rot_width, point_rot_height, tex_u, tex_v, tex_width, tex_height, tex_xcount, tex_ycount, tex_xindex, tex_yindex, xp0, xp1, xp2, xp3, xp4, xp5, yp0, yp1, yp2, yp3, yp4, yp5;

	//Get the target data structure
	var ds_data = argument0;
	var ds_target = argument1;

	//Get deformation point data
	var ds_point = ds_data[# prop._def_point_data, ds_target];

	//Get deformation rotation
	point_rot_prefetch(argument9);
         
	//Get texel count
	tex_xcount = def_width - 1;
	tex_ycount = def_height - 1;
         
	//Get texel UV dimensions
	tex_u = argument3/tex_xcount;
	tex_v = argument4/tex_ycount;
         
	//Get scaled texel dimensions
	tex_width = tex_u*argument7;
	tex_height = tex_v*argument8;
         
	//Get point rotation offsets
	point_rot_width = point_rot_x(0, tex_height);
	point_rot_height = point_rot_y(tex_width, 0);


	/*
	DRAW DEFORMATION
	*/

	draw_set_alpha(argument10);
	draw_primitive_begin_texture(pr_trianglelist, argument2);
	for (tex_yindex = 0; tex_yindex < (ds_grid_height(ds_point) - def_width - 1); tex_yindex += 1) {
	   //Convert 1D point data to 2D
	   tex_target = tex_yindex;
	   tex_xindex = tex_yindex mod def_width;
	   tex_yindex = tex_yindex div def_width;
   
	   //Wrap triangles to new row when row is complete
	   if (tex_xindex == tex_xcount) {
	      tex_yindex = tex_target;
	      continue;
	   }
   
	   //Get point coordinates
	   point_x = argument5 + point_rot_x((tex_width*tex_xindex), (tex_height*tex_yindex));
	   point_y = argument6 + point_rot_y((tex_width*tex_xindex), (tex_height*tex_yindex));
	   point_width = point_rot_x(tex_width, tex_height);
	   point_height = point_rot_y(tex_width, tex_height);
   
	   //Get opposite triangle coordinates
	   xp0 = point_x;
	   xp1 = point_x - point_rot_width + point_width;
	   xp2 = point_x + point_rot_width;
   
	   yp0 = point_y;
	   yp1 = point_y + point_rot_height;
	   yp2 = point_y - point_rot_height + point_height;

	   //Get adjacent triangle coordinates
	   xp3 = point_x + point_rot_width;
	   xp4 = point_x - point_rot_width + point_width;
	   xp5 = point_x + point_width;
   
	   yp3 = point_y - point_rot_height + point_height;
	   yp4 = point_y + point_rot_height;
	   yp5 = point_y + point_height;
   
	   //Animate opposite triangles
	   xp0 += point_rot_x(ds_point[# prop._xpoint, tex_target]*argument7,             ds_point[# prop._ypoint, tex_target]*argument8);
	   xp1 += point_rot_x(ds_point[# prop._xpoint, tex_target + 1]*argument7,         ds_point[# prop._ypoint, tex_target + 1]*argument8);
	   xp2 += point_rot_x(ds_point[# prop._xpoint, tex_target + def_width]*argument7, ds_point[# prop._ypoint, tex_target + def_width]*argument8);
   
	   yp0 += point_rot_y(ds_point[# prop._xpoint, tex_target]*argument7,             ds_point[# prop._ypoint, tex_target]*argument8);
	   yp1 += point_rot_y(ds_point[# prop._xpoint, tex_target + 1]*argument7,         ds_point[# prop._ypoint, tex_target + 1]*argument8);
	   yp2 += point_rot_y(ds_point[# prop._xpoint, tex_target + def_width]*argument7, ds_point[# prop._ypoint, tex_target + def_width]*argument8);
   
	   //Animate adjacent triangles
	   xp3 += point_rot_x(ds_point[# prop._xpoint, tex_target + def_width]*argument7,     ds_point[# prop._ypoint, tex_target + def_width]*argument8);
	   xp4 += point_rot_x(ds_point[# prop._xpoint, tex_target + 1]*argument7,             ds_point[# prop._ypoint, tex_target + 1]*argument8);
	   xp5 += point_rot_x(ds_point[# prop._xpoint, tex_target + def_width + 1]*argument7, ds_point[# prop._ypoint, tex_target + def_width + 1]*argument8);
   
	   yp3 += point_rot_y(ds_point[# prop._xpoint, tex_target + def_width]*argument7,     ds_point[# prop._ypoint, tex_target + def_width]*argument8);
	   yp4 += point_rot_y(ds_point[# prop._xpoint, tex_target + 1]*argument7,             ds_point[# prop._ypoint, tex_target + 1]*argument8);
	   yp5 += point_rot_y(ds_point[# prop._xpoint, tex_target + def_width + 1]*argument7, ds_point[# prop._ypoint, tex_target + def_width + 1]*argument8);
   
	   //Draw opposite triangles
	   draw_vertex_texture(xp0, yp0, (tex_u*tex_xindex)/argument3,           (tex_v*tex_yindex)/argument4);
	   draw_vertex_texture(xp1, yp1, ((tex_u*tex_xindex) + tex_u)/argument3, (tex_v*tex_yindex)/argument4);
	   draw_vertex_texture(xp2, yp2, (tex_u*tex_xindex)/argument3,           ((tex_v*tex_yindex) + tex_v)/argument4);
   
	   //Draw adjacent triangles
	   draw_vertex_texture(xp3, yp3, (tex_u*tex_xindex)/argument3,           ((tex_v*tex_yindex) + tex_v)/argument4);
	   draw_vertex_texture(xp4, yp4, ((tex_u*tex_xindex) + tex_u)/argument3, (tex_v*tex_yindex)/argument4);
	   draw_vertex_texture(xp5, yp5, ((tex_u*tex_xindex) + tex_u)/argument3, ((tex_v*tex_yindex) + tex_v)/argument4);
   
	   //Continue to next point
	   tex_yindex = tex_target;
	}
	draw_primitive_end();
	draw_set_alpha(1);


}
