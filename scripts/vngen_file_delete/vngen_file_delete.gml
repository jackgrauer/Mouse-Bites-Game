/// @function	vngen_file_delete(filename);
/// @param		{string}	filename
/// @author		Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright	XGASOFT 2020, All Rights Reserved
function vngen_file_delete(argument0) {

	/*
	Attempts to delete the specified save file from the hard disk and returns true or false
	to indicate whether the operation succeeded.

	Note that due to GameMaker being sandboxed, this script may not succeed depending on file
	location and system permissions.

	argument0 = filename of the save file to be deleted, including path and extension (string)

	Example usage:
	   vngen_file_delete(working_directory + "save.dat");
   
	   if (vngen_file_delete(working_directory + "save.dat") == false) {
	      show_message("Delete failed!");
	   }
	*/

	//If the file exists...
	if (file_exists(argument0)) {
	   //Attempt to delete and return deletion report
	   return file_delete(argument0);
	} else {
	   //Otherwise return false if file does not exist
	   return false;
	}


}
