/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro testsq(num=1000);
    %local i;
    %do i=1 %to &num.;
        %if "&i"="" %then %put &i.;
    %end;
%mend;