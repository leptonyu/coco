/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro sas_str_addmid(string, midfix, sep);
    %if %length(&sep.)=0 %then
        %let sep=%str( );
    %sysfunc(tranwrd(%sysfunc(compbl(&string.)), %str(&sep.), %str(&midfix.)))
%mend;