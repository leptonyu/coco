/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro isfileref(ref);
    %local re;
    %let re=0;

    %if %length(&ref.) %then
        %do;
            %if %sysfunc(fileref(&ref.))<=0 %then
                %do;
                    %let re=1;
                %end;
        %end;
   &re.
%mend;