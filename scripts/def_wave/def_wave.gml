/// @function	def_wave();
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function def_wave() {

	/*
	A deformation for use with vngen_*_deform_start scripts.

	Deformations following this template are universal and can be applied 
	to scenes, characters, attachments, textboxes, labels, and prompts.

	All deformation values are relative to the base values of the entity 
	being modified. Some properties (position, scale, color, alpha) carry
	over from animations, so deformations and animations can be combined.

	Deformation values are notated as points in a 2D mesh, dividing the
	target entity into rows and columns which can then be manipulated,
	stretching the entity between each point. Each point is comprised of
	an xpoint and ypoint pair of values. These values are written as
	2D arrays, where the first index refers to the row and the second
	index refers to the column at which the point is located. To visualize
	this, it may be helpful to arrange xpoint and ypoint definitions in
	a grid within your keyframes.

	By default, all deforms are assumed to be two columns wide and four
	rows tall. This can be changed by supplying a "if deform() { }"
	argument at the start of the script and setting custom def_width and
	def_height values inside.

	Setting a value for each variable in each keyframe is optional,
	however any unused variables will be treated as default. Values
	will be transitioned smoothly between keyframes.

	Some values are also passed in from the entity being animated,
	such as dimensions and scale, and can be used to create animations
	that scale to any size entity.

	Modifiable variables: 
	   def_width, def_height
	   def_xpoint[0, 0] ... def_xpoint[3, 1]
	   def_ypoint[0, 0] ... def_ypoint[3, 1]
	   def_ease
   
	Available constants:
	   input_width, input_height, input_x, input_y, input_xscale, input_yscale, input_rot
	*/

	/*
	DEFORM
	*/

	if (deform()) {
	   def_width = 2;   //Columns
	   def_height = 16; //Rows
	}


	/*
	KEYFRAMES
	*/

	//Initialize wave properties
	var amp = input_width*0.033;
	var row;

	if (keyframe()) {
	   //Col 0 | Row 0                                    Col 1 | Row 0
	   def_xpoint[0, 0] = (amp*0.4);                      def_xpoint[1, 0] = def_xpoint[0, 0];
   
	   //Col 0 | Row 1                                    Col 1 | Row 1
	   def_xpoint[0, 1] = sin(-0.785395)*amp + (amp*0.4); def_xpoint[1, 1] = def_xpoint[0, 1];
   
	   //Col 0 | Row 2                                    Col 1 | Row 2
	   def_xpoint[0, 2] = sin(-1.570795)*amp + (amp*0.4); def_xpoint[1, 2] = def_xpoint[0, 2];
   
	   //Col 0 | Row 3                                    Col 1 | Row 3
	   def_xpoint[0, 3] = sin(-3.141595)*amp + (amp*0.4); def_xpoint[1, 3] = def_xpoint[0, 3];
   
	   //Col # | Row #                                    Col # | Row #
	   for (row = 4; row < def_height; row += 1) {
	      def_xpoint[0, row] = def_xpoint[0, row mod 4];  def_xpoint[1, row] = def_xpoint[0, row mod 4];
	   }
	}

	if (keyframe()) {
	   //Col 0 | Row 0                                    Col 1 | Row 0
	   def_xpoint[0, 0] = sin(-3.141595)*amp + (amp*0.4); def_xpoint[1, 0] = def_xpoint[0, 0];
   
	   //Col 0 | Row 1                                    Col 1 | Row 1
	   def_xpoint[0, 1] = (amp*0.4);                      def_xpoint[1, 1] = def_xpoint[0, 1];
   
	   //Col 0 | Row 2                                    Col 1 | Row 2
	   def_xpoint[0, 2] = sin(-0.785395)*amp + (amp*0.4); def_xpoint[1, 2] = def_xpoint[0, 2];
   
	   //Col 0 | Row 3                                    Col 1 | Row 3
	   def_xpoint[0, 3] = sin(-1.570795)*amp + (amp*0.4); def_xpoint[1, 3] = def_xpoint[0, 3];
   
	   //Col # | Row #                                    Col # | Row #
	   for (row = 4; row < def_height ; row += 1) {
	      def_xpoint[0, row] = def_xpoint[0, row mod 4];  def_xpoint[1, row] = def_xpoint[0, row mod 4];
	   }
	}

	if (keyframe()) {
	   //Col 0 | Row 0                                    Col 1 | Row 0
	   def_xpoint[0, 0] = sin(-1.570795)*amp + (amp*0.4); def_xpoint[1, 0] = def_xpoint[0, 0];
   
	   //Col 0 | Row 1                                    Col 1 | Row 1
	   def_xpoint[0, 1] = sin(-3.141595)*amp + (amp*0.4); def_xpoint[1, 1] = def_xpoint[0, 1];
   
	   //Col 0 | Row 2                                    Col 1 | Row 2
	   def_xpoint[0, 2] = (amp*0.4);                      def_xpoint[1, 2] = def_xpoint[0, 2];
   
	   //Col 0 | Row 3                                    Col 1 | Row 3
	   def_xpoint[0, 3] = sin(-0.785395)*amp + (amp*0.4); def_xpoint[1, 3] = def_xpoint[0, 3];
   
	   //Col # | Row #                                    Col # | Row #
	   for (row = 4; row < def_height; row += 1) {
	      def_xpoint[0, row] = def_xpoint[0, row mod 4];  def_xpoint[1, row] = def_xpoint[0, row mod 4];
	   }
	}

	if (keyframe()) {
	   //Col 0 | Row 0                                    Col 1 | Row 0
	   def_xpoint[0, 0] = sin(-0.785395)*amp + (amp*0.4); def_xpoint[1, 0] = def_xpoint[0, 0];
   
	   //Col 0 | Row 1                                    Col 1 | Row 1
	   def_xpoint[0, 1] = sin(-1.570795)*amp + (amp*0.4); def_xpoint[1, 1] = def_xpoint[0, 1];
   
	   //Col 0 | Row 2                                    Col 1 | Row 2
	   def_xpoint[0, 2] = sin(-3.141595)*amp + (amp*0.4); def_xpoint[1, 2] = def_xpoint[0, 2];
   
	   //Col 0 | Row 3                                    Col 1 | Row 3
	   def_xpoint[0, 3] = (amp*0.4);                      def_xpoint[1, 3] = def_xpoint[0, 3];
   
	   //Col # | Row #                                    Col # | Row #
	   for (row = 4; row < def_height; row += 1) {
	      def_xpoint[0, row] = def_xpoint[0, row mod 4];  def_xpoint[1, row] = def_xpoint[0, row mod 4];
	   }
	}


}
