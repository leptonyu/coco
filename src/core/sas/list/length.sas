/*************************************************
 * Copyright(c) 2016 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2016-02-10 22:04:10
 * @version 1.0
 *
 *************************************************/
%macro sas_list_length(list_ref);
    %local value;

    %if %symexist(g_sas_pool_&list_ref.) %then
        %do;
            %let value=%eval(%sysfunc(count(&&&g_sas_pool_&list_ref., |))-1);
        %end;
    %else
        %do;
            %let value=0;
        %end;
    &value.
%mend;
