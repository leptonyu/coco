/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro assertref(_refname_);
    %if "&_refname_."="" %then
        %do;
            %put ERROR: Empty parameter!;
            %abort;
        %end;
    %else %if not %symexist(&_refname_.) %then
        %do;
            %put ERROR: &_refname_. is NOT macro variable!;
            %abort;
        %end;
%mend;