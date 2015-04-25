/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-25 13:37:34
 * @version 1.0
 * @desp check value is in list.
 *************************************************/
 
%macro sas_str_contain(list, value);
    %local rc;
    %let rc=0;
    %if "&value."="" %then
        %goto exit;
    %local i v;
    %let i=1;
    %let v=%scan(&list., &i., %str( ));
    %do %while("&v."^="");
        %if "&v."="&value." %then
            %do;
                %let rc=1;
                %goto exit;
            %end;
        %let i=%eval(&i.+1);
        %let v=%scan(&list., &i., %str( ));
    %end;
%exit:
    &rc.
%mend;
