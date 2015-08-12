/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(printstack);

%macro assertref(_refname_);
    %if "&_refname_."="" %then
        %do;
            %printstack(Empty parameter!);
        %end;
    %else %if not %symexist(&_refname_.) %then
        %do;
            %printstack(&_refname_. is NOT macro variable!);
        %end;
%mend;