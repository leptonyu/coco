/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro testprint;
    %put MACRO<&sysmacroname.> is in another source path.;
%mend;