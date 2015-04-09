/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro sas_str_addpre(string, prefix, sep, sep2);
    %if %length(&sep.)=0 %then
        %let sep=%str( );

    %if %length(&sep2.)=0 %then
        %let sep2=&sep.;
    &prefix.%sysfunc(tranwrd(%sysfunc(compbl(&string.)), &sep., 
        &sep2.&prefix.))
%mend;