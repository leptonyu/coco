/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro hasprefix(str, prefix);
    %local re lens lenp;
    %let lens=%length(&str.);
    %let lenp=%length(&prefix.);
    %let re=0;

    %if &lenp.=0 %then
        %do;
            %let re=1;
        %end;
    %else %if &lens. >=&lenp. and &lenp.>0 %then
        %do;

            %if %index(&str., &prefix.)=1 %then
                %do;
                    %let re=1;
                %end;
        %end;
    &re.
%mend;