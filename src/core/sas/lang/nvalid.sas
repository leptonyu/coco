/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro nvalid(name);
    %local rc;

    %if %length(&name.)=0 %then
        %do;
            %let rc=0;
        %end;
    %else
        %do;
            %let rc=%qsysfunc(nvalid(&name.));
        %end;
    &rc.
%mend;