/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro ismacroref(_mref_);
    %if %sysfunc(compress("&_mref_."))="" %then
        %do;
            0
        %end;
    %else %do;
            %sysfunc(ifn(%symexist(&_mref_.),1,0))
        %end;
%mend;