/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-26 09:51:02
* @version 1.0
* 
*************************************************/

%import(hasprefix);
 
%macro sas_map_valid(map);
    %local is;
    %if not %symexist(&map.) or not %hasprefix(&map.,g_sas_map_) %then %do;
        %let is=0;
    %end;%else %do;
        %let is=1;
    %end;
    &is.
%mend;
