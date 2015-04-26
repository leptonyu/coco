/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-26 09:42:55
* @version 1.0
* 
*************************************************/
 
%macro sas_map_name(index);
   g_sas_map_%sysfunc(int(&index.),hex8.)
%mend;
