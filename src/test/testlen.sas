/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro testlen(num=100000);
    %local i;
    %do i=1 %to &num.;
        %if %length(&i.)=0 %then %put &i.;
    %end;
%mend;