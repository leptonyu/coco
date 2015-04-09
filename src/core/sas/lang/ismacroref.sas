/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro ismacroref(_refname_);
    %local re;
    %if %sysfunc(compress("&_refname_."))="" %then
        %do;
            %let re=0;
        %end;
    %else %if %symexist(&_refname_.) %then
        %do;
            %let re=1;
        %end;
    %else
        %do;
            %let re=0;
        %end;
    &re.
%mend;