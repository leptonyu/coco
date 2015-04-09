/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(sas_str_addmid);
%import(sas_str_merge);

%macro sas_str_addcq(string, sep);
    %if %length(&sep.)=0 %then
        %let sep=%str( );
    %let string=%sas_str_merge(%str(&string.), , , %str(%"), %str(%"), 
        sep=%str(&sep.));
    %sas_str_addmid(&string., %str(,), sep=%str(&sep.)) 
%mend;